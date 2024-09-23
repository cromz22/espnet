#!/bin/bash

set -euo pipefail

log() {
    local fname=${BASH_SOURCE[1]##*/}
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S') (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $*"
}
SECONDS=0

stage=1
stop_stage=3

. ./db.sh || exit 1;


if [ ! -e "${GIGASPEECH}" ]; then
    log "Fill the value of 'GIGASPEECH' of db.sh"
    exit 1
fi

if [ ! -e "${GIGAST}" ]; then
    log "Fill the value of 'GIGAST' of db.sh"
    exit 1
fi

if [ ! -e "${GIGAS2S}" ]; then
    log "Fill the value of 'GIGAS2S' of db.sh"
    exit 1
fi

if [ ${stage} -le 1 ] && [ ${stop_stage} -ge 1 ]; then
    log "GigaSpeech data preparation"

    if [ -d "${GIGASPEECH}/audio" ] && [ -f "${GIGASPEECH}/GigaSpeech.json" ]; then
        . local/gigaspeech_data_prep.sh
    else
        log "Valid GigaSpeech data not found in ${GIGASPEECH}."
        log "Please follow the instruction at https://github.com/SpeechColab/GigaSpeech to download the data."
        exit 1
    fi

fi

log "Successfully finished. [elapsed=${SECONDS}s]"
