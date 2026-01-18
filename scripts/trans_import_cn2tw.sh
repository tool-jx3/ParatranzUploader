#!/usr/bin/env bash

trans() {
    cnpath=$1
    twpath=${cnpath/LimbusCompany_Data\/Lang\/LLC_zh-CN/TW}
    dir_path=$(dirname ${twpath})
    mkdir -p ${dir_path}
    opencc -i ${cnpath} -o ${twpath} -c ./opencc/custom.json
    # echo ${cnpath} ${twpath} ${dir_path}
}

cd "$(dirname "$0")"
cd ..

rm ./import/TW/*.json
rm ./import/TW/**/*.json

echo start "$(date +"%Y/%m/%d %H:%M:%S")"

for dir in ./import/LimbusCompany_Data/Lang/LLC_zh-CN/**/*.json
do
    trans ${dir}
    # exit
done

for dir in ./import/LimbusCompany_Data/Lang/LLC_zh-CN/*.json
do
    trans ${dir}
    # exit
done

echo finish "$(date +"%Y/%m/%d %H:%M:%S")"

