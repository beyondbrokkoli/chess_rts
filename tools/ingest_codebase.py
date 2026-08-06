import os
import sys
import uuid
import re
import requests
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams, PointStruct

# --- Configuration ---
QDRANT_URL = "http://localhost:6333"
COLLECTION_NAME = "weaver_dev_nomic"
GEMINI_DIMENSIONS = 768 # Matches Nomic natively

LOCAL_EMBED_URL = "http://10.0.0.2:8081/v1/embeddings"
LOCAL_API_KEY = "TEST1234"

DOT_FILE_LUA = "docs/deps_lua.dot"
DOT_FILE_C = "docs/deps_c.dot"
DOT_FILE_GLSL = "docs/deps_glsl.dot"

# --- THE ABSOLUTE SOURCE OF TRUTH ---
INGESTION_MANIFEST = [
    # Build System
    "build/ctx_build.lua",
    "build/export_c_hdr.lua",
    "build/export_glsl.lua",
    "build/task_c_objects.lua",
    "build/task_headless.lua",
    "build/task_invariants.lua",
    "build/task_shaders.lua",

    # Generated Files (Headers & GLSL)
    "gen/registry.glsl",
    "gen/ssot_net.h",
    "gen/ssot_render.h",
    "gen/ssot_types.h",

    # Host Layer (C Code)
    "host/lifecycle.c",
    "host/lua_vm.c",
    "host/mailbox.c",
    "host/main_loop.c",
    "host/main.c",
    "host/main_headless.c",
    "host/ring_stream.c",
    "host/state_globals.c",
    "host/state_types.c",
    "host/sys_sync.c",
    "host/thread_lifecycle.c",
    "host/thread_pool.c",

    # Network Layer (C Code)
    "network/net_poll.c",
    "network/net_socket.c",
    "network/net_state.c",
    "network/net_utils.c",

    # Render Layer (C Code)
    "render/vk_debug.c",
    "render/vk_record.c",
    "render/vk_draw.c",
    "render/vk_render_loop.c",
    "render/vk_tenant_alloc.c",
    "render/vk_transfer_api.c",
    "render/vk_transfer_loop.c",

    # Shaders
    "shaders/render.frag",
    "shaders/render.vert",
    "shaders/shared.glsl",

    # Single Source of Truth (SSOT)
    "ssot/config_gfx.lua",
    "ssot/config_net.lua",
    "ssot/config_sim.lua",
    "ssot/ctx_types.lua",
    "ssot/registry.glsl",
    "ssot/type_math.lua",
    "ssot/type_net.lua",
    "ssot/type_render.lua",

    # Tenant Layer (C Code)
    "tenant/tenant_callbacks_state.c",
    "tenant/tenant_callbacks_mouse.c",
    "tenant/tenant_callbacks_key.c",
    "tenant/tenant_input.c",
    "tenant/tenant_sys.c"
]

def parse_dependencies(dot_filepath):
    deps_map = {}
    if not os.path.exists(dot_filepath):
        print(f"[-] Dependency graph '{dot_filepath}' not found. Skipping topology injection.")
        return deps_map

    with open(dot_filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    edges = re.findall(r'"([^"]+)"\s*->\s*"([^"]+)"', content)
    for source, target in edges:
        if source not in deps_map:
            deps_map[source] = []
        deps_map[source].append(target)

    return deps_map

def validate_lua_invariants(module_name, source_code, expected_deps_from_dot):
    matches = re.findall(r'require\s*\(\s*["\']([^"\']+)["\']\s*\)|require\s+["\']([^"\']+)["\']', source_code)

    actual_requires = set()
    for match in matches:
        req = match[0] if match[0] else match[1]
        if req not in ["ffi", "math", "bit", "os", "io", "string"]:
            actual_requires.add(req)

    expected_requires = set(expected_deps_from_dot)
    expected_requires = {dep for dep in expected_requires if dep not in ["ffi", "math", "bit"]}

    if actual_requires != expected_requires:
        print(f"\n[FATAL INVARIANT] Architecture drift detected in '{module_name}.lua'")
        print(f" |- Expected (deps_lua.dot): {expected_requires}")
        print(f" |- Actual (Lua source):  {actual_requires}")
        sys.exit(1)

def validate_include_invariants(file_name, source_code, expected_deps_from_dot, domain="C"):
    matches = re.findall(r'#include\s+"([^"]+)"', source_code)

    actual_requires = set()
    for match in matches:
        actual_requires.add(os.path.basename(match))

    expected_requires = set(expected_deps_from_dot)

    if actual_requires != expected_requires:
        print(f"\n[FATAL INVARIANT] {domain} Architecture drift detected in '{file_name}'")
        print(f" |- Expected (deps_{domain.lower()}.dot): {expected_requires}")
        print(f" |- Actual ({domain} source):     {actual_requires}")
        sys.exit(1)

def get_embedding(text):
    headers = {
        "Authorization": f"Bearer {LOCAL_API_KEY}",
        "Content-Type": "application/json"
    }
    payload = {"input": text}
    response = requests.post(LOCAL_EMBED_URL, headers=headers, json=payload)
    response.raise_for_status()
    return response.json()['data'][0]['embedding']

def main():
    print(f"\n=== LOCAL NOMIC EMBEDDING RUN ({COLLECTION_NAME}) ===")
    print("Connecting to Qdrant...")
    qdrant = QdrantClient(url=QDRANT_URL)

    if qdrant.collection_exists(collection_name=COLLECTION_NAME):
        print(f" [!] Purging existing '{COLLECTION_NAME}'...")
        qdrant.delete_collection(collection_name=COLLECTION_NAME)

    print(f" [*] Creating fresh Qdrant collection '{COLLECTION_NAME}'...")
    qdrant.create_collection(
        collection_name=COLLECTION_NAME,
        vectors_config=VectorParams(size=GEMINI_DIMENSIONS, distance=Distance.COSINE),
    )

    print("Parsing architecture topologies...")
    topology_lua = parse_dependencies(DOT_FILE_LUA)
    topology_c = parse_dependencies(DOT_FILE_C)
    topology_glsl = parse_dependencies(DOT_FILE_GLSL)
    points = []

    print(f"Validating and vectorizing {len(INGESTION_MANIFEST)} manifested files...\n")

    for filepath in INGESTION_MANIFEST:
        if not os.path.exists(filepath):
            print(f" [WARNING] File missing from disk: {filepath}")
            continue

        filename = os.path.basename(filepath)
        module_name = os.path.splitext(filename)[0]
        ext = os.path.splitext(filename)[1].lower()

        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            source_code = f.read().strip()

        if not source_code:
            continue

        # --- INVARIANT ASSERTION & DEPENDENCY RESOLUTION ---
        if ext == ".lua":
            dependencies = topology_lua.get(module_name, [])
            validate_lua_invariants(module_name, source_code, dependencies)
        elif ext in [".c", ".h"]:
            dependencies = topology_c.get(filename, [])
            validate_include_invariants(filename, source_code, dependencies, domain="C")
        elif ext in [".glsl", ".frag", ".vert"]:
            dependencies = topology_glsl.get(filename, [])
            validate_include_invariants(filename, source_code, dependencies, domain="GLSL")
        else:
            dependencies = []

        dep_string = ", ".join(dependencies) if dependencies else "None (Level 0 / Root)"
        contextual_payload = (
            f"MODULE: {filepath}\n"
            f"DEPENDENCIES: {dep_string}\n"
            f"SOURCE CODE:\n{source_code}"
        )

        print(f" [OK] Vectorizing Module: {filepath} (Deps: {len(dependencies)})")
        vector = get_embedding(contextual_payload)

        point_id = str(uuid.uuid5(uuid.NAMESPACE_URL, filepath))
        points.append(PointStruct(
            id=point_id,
            vector=vector,
            payload={
                "file": filepath,
                "dependencies": dependencies,
                "content": source_code,
                "full_context": contextual_payload
            }
        ))

    if points:
        print(f"\nUpserting {len(points)} modules into Qdrant...")
        qdrant.upsert(
            collection_name=COLLECTION_NAME,
            points=points
        )
        print("Codebase successfully indexed and mapped!")
    else:
        print("No valid files found to index.")

if __name__ == "__main__":
    main()
