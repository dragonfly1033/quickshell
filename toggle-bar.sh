#!/bin/sh

output=$(niri msg focused-output | head -n 1 | sed -r 's/.*\((.*)\)/\1/')

quickshell ipc call bar."$output" toggle 