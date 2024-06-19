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

wait_for_server() {
  # wait for vllm server to start
  # return 1 if vllm server crashes
  timeout 1200 bash -c '
    until curl localhost:8000/v1/completions; do
      sleep 1
    done' && return 0 || return 1
}

python3 -m vllm.entrypoints.openai.api_server \
    --model meta-llama/Llama-2-7b-hf \
    --tensor-parallel-size 1 \
    --swap-space 16 \
    --disable-log-stats  \
    --disable-log-requests  \
    --load-format dummy \
    --dtype bfloat16 \
    --device cpu &

SERVER_PID=$!

wait_for_server

for qps in 1 4 16
do
    client_command="python3 benchmark_serving.py \
            --save-result \
            --result-dir results \
            --result-filename serving_llama2_7b_tp1_sharegpt_qps_$qps.json \
            --request-rate $qps \
            --model meta-llama/Llama-2-7b-hf \
            --dataset-name sharegpt \
            --dataset-path ./ShareGPT_V3_unfiltered_cleaned_split.json  \
            --num-prompts 10"
    eval "$client_command"
done

sudo kill -9 $SERVER_PID