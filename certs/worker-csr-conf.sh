#!/usr/bin/env bash

infile="./ca-csr.json"
for instance in worker-0 worker-1 worker-2
do
  outfile="./${instance}-csr.json"
  CN="system:node:${instance}"
  O="system:nodes"
  cat ${infile} | jq ".CN=\"${CN}\" | .names[].O=\"system:nodes\"" > ${outfile}
done