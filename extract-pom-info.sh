#!/bin/bash

find m2/ -type f -name "*.pom" -exec bash -c '
  extract_pom_info() {
    local pom_file="$1"
    local groupid=""
    local artifactId=""
    local version=""

    groupid=$(grep -oP "<groupId>\K[^<]*" "$pom_file")
    artifactId=$(grep -oP "<artifactId>\K[^<]*" "$pom_file")
    version=$(grep -oP "<version>\K[^<]*" "$pom_file")

    echo "$groupid:$artifactId:$version"
  }

  extract_pom_info "$0" 
' {} \;
