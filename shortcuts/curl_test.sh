#!/bin/bash -x

curl http://localhost:8000/v1/completions \
-H "Content-Type: application/json" \
-d '{
  "model": "llama2-70b",
  "prompt": "San Francisco is a",
  "max_tokens": 32,
  "temperature": 0
}' | jq '.choices[0].text'