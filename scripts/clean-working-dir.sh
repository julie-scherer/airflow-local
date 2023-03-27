#!/bin/bash

: <<DOCUMENTATION

Delete all the .env file and directories
created when you ran the script to run 
Airflow locally.

DOCUMENTATION

declare -a dirs=("/airflow" "/dags" "/logs" "/plugins" "/venv")

for dir in "${dirs[@]}"; do
  DIR_PATH="$PWD/$dir"
  if [ -d $DIR_PATH ]; then echo "Deleting $DIR_PATH" && rm -rf $DIR_PATH ; fi
done

if [ -f .env ]; then echo "Deleting .env file ..." && rm -f .env ; fi