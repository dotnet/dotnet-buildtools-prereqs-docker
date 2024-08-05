#!/usr/bin/env bash

set -e

if [ $# -eq 0 ]; then
  echo "No function name provided. Usage: ./test.sh <ownersAreTeams|pathsAreUsed|dockerfilesHaveOwners>"
  exit 1
fi

declare -A codeOwnerEntries
readCodeOwnersFile() {
  codeOwnersFilePath="CODEOWNERS"
  
  while IFS= read -r line; do
    # Skip blank lines and comments
    if [[ "$line" =~ ^\s*# ]] || [[ -z "$line" ]] || [[ "$line" =~ ^[[:space:]]*$ ]]; then
        continue
    fi

    path=$(echo "$line" | awk '{print $1}' | sed 's/[[:space:]]*$//')
    owner=$(echo "$line" | sed 's/^[^ ]* //' | sed 's/[[:space:]]*$//')

    # Escape periods
    path=$(echo "$path" | sed 's/\./\\./g')

    # Single * matches anything that is not a slash
    # Double ** matches anything
    # Trailing / matches anything
    # Remove leading slashes
    path=$(echo "$path" | sed -E 's/([^*]|^)\*([^*]|$)/\1[^\/]*\2/g')
    path=$(echo "$path" | sed 's/\*\*/.*/g')
    if [[ "${path: -1}" == "/" ]]; then
      path="$path.*"
    fi
    path=$(echo "$path" | sed 's/^\///')
    path="^$path$"

    # Use git check-ignore to determine if the path matches the patterns
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
  allFiles=$(find . -type f | sed 's/^\.\///')
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
  dockerfiles=$(find . -type f -name "Dockerfile" | sed 's/^\.\///')
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