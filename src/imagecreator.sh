#!/usr/bin/env bash

if [ $# -eq 0 ];then
    echo "No arguments supplied"
    exit 1
fi

echo "Reading configuration from $1"
cat $1
