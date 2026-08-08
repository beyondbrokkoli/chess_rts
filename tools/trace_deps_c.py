import os
import re
from collections import defaultdict

C_DIRS = ["host", "network", "render", "generated"]
INCLUDE_PATTERN = re.compile(r'#include\s+"([^"]+)"')

def sanitize_id(filepath):
    # Converts 'host/boot/main.c' into a safe Mermaid ID: 'host_boot_main_c'
    return re.sub(r'[^a-zA-Z0-9_]', '_', filepath)

def scan_dependencies():
    file_map = {}

    # Pass 1: Build an index mapping file basenames to their namespaced relative paths
    for d in C_DIRS:
        if not os.path.exists(d): continue
        for root, _, files in os.walk(d):
            for file in files:
                if file.endswith((".c", ".h")):
                    rel_path = os.path.relpath(os.path.join(root, file)).replace("\\", "/")
                    file_map[file] = rel_path

    graph = defaultdict(list)

    # Pass 2: Extract dependencies and resolve to namespaces
    for d in C_DIRS:
        if not os.path.exists(d): continue
        for root, _, files in os.walk(d):
            for file in files:
                if not file.endswith((".c", ".h")): continue
                filepath = os.path.join(root, file)
                rel_path = os.path.relpath(filepath).replace("\\", "/")

                # Ensure every file is registered even if it has no dependencies
                if rel_path not in graph:
                    graph[rel_path] = []

                with open(filepath, 'r', encoding='utf-8') as f:
                    for line in f:
                        if line.lstrip().startswith("//"): continue
                        for req in INCLUDE_PATTERN.findall(line):
                            req_clean = os.path.basename(req)
                            # Resolve to relative path if known, else keep as external
                            resolved_path = file_map.get(req_clean, req_clean)
                            graph[rel_path].append(resolved_path)
    return graph

def generate_mermaid(graph):
    all_nodes = set(graph.keys())
    for edges in graph.values():
        all_nodes.update(edges)

    groups = defaultdict(list)
    for node in all_nodes:
        # Group by top-level axis. If no path separators, categorize as 'external'
        group = node.split('/')[0] if '/' in node else 'external'
        groups[group].append(node)

    lines = ["```mermaid", "graph TD", "    %% WeaverEngine C Dependencies"]

    # Cluster nodes into subgraphs based on top-level axes
    for group, nodes in sorted(groups.items()):
        lines.append(f"    subgraph {group}")
        for node in sorted(nodes):
            lines.append(f'        {sanitize_id(node)}["{node}"]')
        lines.append("    end")

    # Draw edges
    for src in sorted(graph.keys()):
        src_id = sanitize_id(src)
        for dst in sorted(set(graph[src])):
            dst_id = sanitize_id(dst)
            lines.append(f"    {src_id} --> {dst_id}")

    lines.append("```\n")
    return "\n".join(lines)

if __name__ == "__main__":
    deps = scan_dependencies()
    mmd_output = generate_mermaid(deps)

    os.makedirs("docs", exist_ok=True)
    out_file = "docs/deps_c.md"
    with open(out_file, "w") as f:
        f.write(mmd_output)
    print(f"Generated {out_file}")
