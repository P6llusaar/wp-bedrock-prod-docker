#!/usr/bin/env bash

version=$1
server_color=$2

if [ -z "$version" ] || [ -z "$server_color" ]; then
    echo "Error: version and server color need to be set"
    echo "Usage: $0 [version] [blue|green]"
    exit 1
fi

if [ "$server_color" != "green" ] && [ "$server_color" != "blue" ]; then
    echo "Error: server color has to be either blue or green"
    exit 1;
fi

docker compose down "bedrock-${server_color}"
docker compose build --build-arg git_branch="$version" "bedrock-${server_color}"
docker compose up -d "bedrock-${server_color}"


