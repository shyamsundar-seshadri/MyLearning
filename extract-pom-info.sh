#!/bin/bash

find m2/ -type f -name "*.pom" -exec bash -c '
    extract_pom_info() {
        local pom_file="$1"
        local groupid=""
        local artifactId=""
        local version=""

        groupid=$(grep '<groupId>' "$pom_file" | cut -d'>' -f2 | cut -d'<' -f1)
        artifactId=$(grep '<artifactId>' "$pom_file" | cut -d'>' -f2 | cut -d'<' -f1)
        version=$(grep '<version>' "$pom_file" | cut -d'>' -f2 | cut -d'<' -f1)

        echo "$groupid:$artifactId:$version"
    }
    extract_pom_info "$0"
' {} \;
