#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

train_conf=conf/train.conf

./speechlm.sh \
    --stage 1 \
    --stop_stage 2 \
    --task "ssl_codec_s2st" \
    --data_name gigas2s \
    --train_set "train" \
    --valid_set "dev" \
    --test_sets "test" \
    --train_config ${train_conf}

