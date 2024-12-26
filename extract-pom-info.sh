#!/bin/bash

# Function to extract groupid, artifactId, and version from a POM file
extract_pom_info() {
  local pom_file="$1"
  local groupid=""
  local artifactId=""
  local version=""

  # Use grep to extract the desired information
  groupid=$(grep '<groupId>' "$pom_file" | cut -d'>' -f2 | cut -d'<' -f1)
  artifactId=$(grep '<artifactId>' "$pom_file" | cut -d'>' -f2 | cut -d'<' -f1)
  version=$(grep '<version>' "$pom_file" | cut -d'>' -f2 | cut -d'<' -f1)

  echo "$groupid:$artifactId:$version"
}

# Traverse all subfolders in m2 directory
find m2/ -type f -name "*.pom" -exec bash -c 'extract_pom_info "$0"' {} \;
