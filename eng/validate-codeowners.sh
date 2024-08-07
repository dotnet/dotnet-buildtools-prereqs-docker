#!/usr/bin/env bash

set -e

if [ $# -eq 0 ]; then
  echo "No function name provided. Usage: ./validate-codeowners.sh <ownersAreTeams|pathsAreUsed|dockerfilesHaveOwners>"
  exit 1
fi

declare -A codeOwnerEntries
readCodeOwnersFile() {
  codeOwnersFilePath="CODEOWNERS"

  # A newline is needed at the end of the file for the last line to be read
  # but git likes to remove trailing newlines so we add one if it is missing
  if [ "$(tail -c 1 "$codeOwnersFilePath")" != "" ]; then
    echo "" >> "$codeOwnersFilePath"
  fi
  
  while IFS= read -r line; do

    # Skip blank lines, comments, and * paths
    if [[ "$line" =~ ^[[:space:]]*# ]] || [[ "$line" =~ ^[[:space:]]*$ ]] || [[ "$line" =~ ^\*[[:space:]] ]]; then
      continue
    fi

    path=$(echo "$line" | awk '{print $1}' | awk '{$1=$1};1')
    owner=$(echo "$line" | awk '{print $2}' | awk '{$1=$1};1')

    # Escape periods
    path=$(echo "$path" | sed 's/\./\\./g')

    # A single asterisk matches anything that is not a slash (as long as it is not at the beginning of a pattern)
    if [[ ! "$path" =~ ^\* ]]; then
      path=$(echo "$path" | sed -E 's/([^*]|^)\*([^*]|$)/\1[^\/]*\2/g')
    fi

    # Trailing /** and leading **/ should match anything in all directories
    path=$(echo "$path" | sed 's/\/\*\*$/\/.*/g')
    path=$(echo "$path" | sed 's/^\*\*\//.*\//g')

    # /**/ matches zero or more directories
    path=$(echo "$path" | sed 's/\/\*\*\//\/.*/g')

    # If the asterisk is at the beginning of the pattern or the pattern does not start with a slash, then match everything
    if [[ "$path" =~ ^\* ]]; then
      path=".$path"
    elif [[ ! "$path" =~ ^/ && ! "$path" =~ ^\.\* ]]; then
      path=".*$path"
    fi

    # If there is a trailing slash, then match everything below the directory
    if [[ "${path: -1}" == "/" ]]; then
      path="$path.*"
    fi
  
    path="^$path$"

    codeOwnerEntries["$path"]="$owner"
  done < "$codeOwnersFilePath"
}

ownersAreTeams() {
  nonTeamOwners=()

  for codeOwner in "${codeOwnerEntries[@]}"; do
    if [[ "$codeOwner" != *"/"* ]]; then
      nonTeamOwners+=("$codeOwner")
    fi
  done

  if [[ ${#nonTeamOwners[@]} -gt 0 ]]; then
    echo "The following CODEOWNERS are not teams:"
    printf "%s\n" "${nonTeamOwners[@]}"
    exit 1
  fi

  exit 0
}

pathsAreUsed() {
  allFiles=$(find . -type f | sed 's/^\.//')
  unusedPaths=()

  for path in "${!codeOwnerEntries[@]}"; do
    pathUsed=false
    for file in $allFiles; do
      if [[ "$file" =~ $path ]]; then
        pathUsed=true
        break
      fi
    done

    if [[ "$pathUsed" == false ]]; then
      # Undo regex changes
      path=$(echo "$path" | sed 's/\[\^\/\]\*/\*/g' | sed 's/^\^//' | sed 's/\$$//')
      unusedPaths+=("$path")
    fi
  done

  if [[ ${#unusedPaths[@]} -gt 0 ]]; then
    echo "The following paths in the CODEOWNERS file are not used by any file in the repository:"
    printf "%s\n" "${unusedPaths[@]}"
    exit 1
  fi

  exit 0
}

dockerfilesHaveOwners() {
  dockerfiles=$(find . -type f -name "Dockerfile" | sed 's/^\.//')
  filesWithoutOwner=()

  for file in $dockerfiles; do
    ownerFound=false
    for pattern in "${!codeOwnerEntries[@]}"; do
      if [[ "$file" =~ $pattern ]]; then
        ownerFound=true
        break
      fi
    done
    if [ "$ownerFound" = false ]; then
      filesWithoutOwner+=("$file")
    fi
  done

  if [[ ${#filesWithoutOwner[@]} -gt 0 ]]; then
    echo "The following Dockerfiles do not have an owner in the CODEOWNERS file:"
    printf "%s\n" "${filesWithoutOwner[@]}"
    exit 1
  fi

  exit 0
}

# Call the function passed as an argument
readCodeOwnersFile
"$1"