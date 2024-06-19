#!/bin/bash -x

cd ../benchmarks

if ! [ -d results ]
then
    mkdir results
fi

python3 benchmark_latency.py \
    --output-json results/latency_llama2_7b_tp1.json \
    --model meta-llama/Llama-2-7b-hf \
    --tensor-parallel-size 1 \
    --load-format dummy \
    --dtype bfloat16 \
    --output-len 32 \
    --num-iters-warmup 1 \
    --num-iters 4  \
    --device cpu
