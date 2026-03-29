#!/bin/sh

find -P /sys/devices -type f -name 'temp*_input' -path '*18\.3*' | xargs -I {} printf {}