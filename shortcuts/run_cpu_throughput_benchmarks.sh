#!/bin/bash -x

cd ../benchmarks

if ! [ -e ShareGPT_V3_unfiltered_cleaned_split.json ]
then
    wget https://huggingface.co/datasets/anon8231489123/ShareGPT_Vicuna_unfiltered/resolve/main/ShareGPT_V3_unfiltered_cleaned_split.json
fi

if ! [ -d results ]
then
    mkdir results
fi

python3 benchmark_throughput.py \
    --output-json results/throughput_llama2_7b_tp1.json \
    --model meta-llama/Llama-2-7b-hf \
    --tensor-parallel-size 1 \
    --load-format dummy \
    --dtype bfloat16 \
    --output-len 32 \
    --dataset ./ShareGPT_V3_unfiltered_cleaned_split.json \
    --num-prompts 10 \
    --backend vllm  \
    --device cpu
