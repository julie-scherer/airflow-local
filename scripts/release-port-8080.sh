#!/bin/bash

: <<DOCUMENTATION

A solution if you force the app to close and 
get the "Connection in use" error when you
try to run the app again on the same port.

DOCUMENTATION

# Check if there are any processes running on port 8080
if sudo lsof -i :8080; then
    # Kill all processes running on port 8080
    sudo kill $(sudo lsof -t -i :8080)
fi
