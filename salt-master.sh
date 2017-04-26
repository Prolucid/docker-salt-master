#!/bin/bash

salt-master --log-file=${LOG_LOCATION} --log-file-level=${LOG_FILE_LEVEL} -l ${LOG_LEVEL} > /dev/null 2>&1 
