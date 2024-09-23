#!/usr/bin/env bash

set -e
set -u
set -o pipefail

log() {
    local fname=${BASH_SOURCE[1]##*/}
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S') (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $*"
}
SECONDS=0

data_dir="data"
train_subset="XS"  # TODO: Change to XL

. ./db.sh || exit 1;

if [ ! -e "${GIGASPEECH}" ]; then
    log "Fill the value of 'GIGASPEECH' of db.sh"
    exit 1
fi

if [ -d ${data_dir}/train ] || [ -d ${data_dir}/dev ] || [ -d ${data_dir}/test ]; then
    log "Data directory already exists. Please remove it if you want to re-run the script."
    exit 1
fi

abs_data_dir=$(realpath ${data_dir})
local/gigaspeech_kaldi_data_prep.sh --train-subset ${train_subset} ${GIGASPEECH} ${abs_data_dir}

mv ${data_dir}/gigaspeech_train_xs ${data_dir}/train  # TODO: Change to xl
mv ${data_dir}/gigaspeech_dev ${data_dir}/dev
mv ${data_dir}/gigaspeech_test ${data_dir}/test

for split in train dev test; do
    utils/fix_data_dir.sh ${data_dir}/${split}
    # reco2dur causes the error at stage 4 in asr.sh
    rm -f ${data_dir}/${split}/reco2dur
done

log "Successfully finished. [elapsed=${SECONDS}s]"
