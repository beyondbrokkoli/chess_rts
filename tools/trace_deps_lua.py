import os
import re

ROOT_LUA_FILES = []
LUA_DIRS = ["build", "ssot", "staging", "network"]
#LUA_DIRS = ["network"]

REQUIRE_PATTERN = re.compile(r"require\s*(?:\(\s*['\"]([^'\"]+)['\"]\s*\)|['\"]([^'\"]+)['\"])")

def parse_file(filepath, graph):
    mod_name = os.path.splitext(os.path.basename(filepath))[0]
    if mod_name not in graph:
        graph[mod_name] = []

    with open(filepath, 'r', encoding='utf-8') as f:
        for line in f:
            if line.lstrip().startswith("--"):
                continue

            matches = REQUIRE_PATTERN.findall(line)
            for match in matches:
                req = match[0] if match[0] else match[1]
                # KEEP the full namespace (e.g., 'build.task_headless')
                # so it strictly matches the ingest script's regex.
                graph[mod_name].append(req)

def scan_dependencies():
    graph = {}

    for root_file in ROOT_LUA_FILES:
        if os.path.exists(root_file):
            parse_file(root_file, graph)

    for d in LUA_DIRS:
        if not os.path.exists(d):
            continue
        for root, _, files in os.walk(d):
            for file in files:
                if file.endswith(".lua"):
                    filepath = os.path.join(root, file)
                    parse_file(filepath, graph)

    return graph

def generate_dot(graph):
    dot = ["digraph WeaverEngine {", "  node [shape=box, style=filled, fillcolor=lightgray];"]
    for node, edges in graph.items():
        if not edges:
            dot.append(f'  "{node}";')
        for edge in edges:
            dot.append(f'  "{node}" -> "{edge}";')
    dot.append("}")
    return "\n".join(dot) + "\n"

if __name__ == "__main__":
    deps = scan_dependencies()
    dot_output = generate_dot(deps)

    with open("deps_lua.dot", "w") as f:
        f.write(dot_output)

    print("Generated deps_lua.dot.")
