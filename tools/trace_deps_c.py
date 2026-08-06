import os
import re

# The new modular directories containing C code and headers
C_DIRS = ["host", "network", "render", "generated"]

# Matches ONLY local includes: #include "module.h"
INCLUDE_PATTERN = re.compile(r'#include\s+"([^"]+)"')

def scan_dependencies():
    graph = {}
    for d in C_DIRS:
        if not os.path.exists(d):
            continue
        for root, _, files in os.walk(d):
            for file in files:
                if not (file.endswith(".c") or file.endswith(".h")):
                    continue

                filepath = os.path.join(root, file)
                graph[file] = []

                with open(filepath, 'r', encoding='utf-8') as f:
                    for line in f:
                        if line.lstrip().startswith("//"):
                            continue

                        matches = INCLUDE_PATTERN.findall(line)
                        for req in matches:
                            req_clean = os.path.basename(req)
                            graph[file].append(req_clean)
    return graph

def generate_dot(graph):
    dot = ["digraph WeaverEngineC"]
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

    with open("docs/deps_c.dot", "w") as f:
        f.write(dot_output)

    print("Generated docs/deps_c.dot.")
