#!/bin/bash

# MoE model for cpu is not supported yet
# Interesting, must be an absolute path
model="/home/sdp/.cache/huggingface/hub/models--mistralai--Mixtral-8x7B-v0.1/snapshots/985aa055896a8f943d4a9f2572e6ea1341823841"
model="/home/sdp/.cache/huggingface/hub/models--meta-llama--Llama-2-70b-hf/snapshots/3aba440b59558f995867ba6e1f58f21d0336b5bb/"

# MoE model for cpu is not supported yet
served_model_name="mistral-8x7b"
served_model_name="llama2-70b"

numactl -m "0-3" -C 0-55 python -m vllm.entrypoints.openai.api_server \
  --served-model-name $served_model_name \
  --port 8000 \
  --model $model \
  --trust-remote-code \
  --device cpu \
  --dtype bfloat16 \
  --enforce-eager \
  --max-model-len 4096 \
  --max-num-batched-tokens 10240 \
  --max-num-seqs 12 \
  --tensor-parallel-size 1