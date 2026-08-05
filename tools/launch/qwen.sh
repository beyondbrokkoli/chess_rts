#!/bin/bash
####  --host 10.0.0.2 \
/home/halim/llama.cpp/build/bin/llama-server \
  -m /home/halim/models/qwen2.5-coder-32b-instruct-q6_k.gguf \
  -ngl 12 \
  -c 65536 \
  -np 1 \
  -n -1 \
  -fa on \
  -ctk q4_0 \
  -ctv q4_0 \
  -b 512 \
  -t 6 \
  --repeat-penalty 1.15 \
  --host 127.0.0.1 \
  --port 8080 \
  --api-key TEST1234
