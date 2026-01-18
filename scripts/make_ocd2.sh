#!/usr/bin/env bash

# This file is part of ptsd project which is released under GNU GPL v3.0.
# Copyright (c) 2025- Limbus Traditional Mandarin

# change dir to repo root directory
cd "$(dirname "$0")" && cd ..


for txt_name in opencc/dictionary/*.txt
do
    ocd2_name=${txt_name//txt/ocd2}
    opencc_dict -i ${txt_name} -f text -o ${ocd2_name} -t ocd2
done

echo "generate dictionary finish."
