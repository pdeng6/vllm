#!/bin/bash -x

cd ..

# one time effort, and actually we don't need pytorch extral url
# pip install -v -r requirements-cpu.txt --extra-index-url https://download.pytorch.org/whl/cpu

export CMAKE_BUILD_TYPE=RelWithDebInfo
export VLLM_TARGET_DEVICE=cpu

python setup.py install