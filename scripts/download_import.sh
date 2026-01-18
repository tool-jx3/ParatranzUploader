#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")" && cd ..

REPO="LocalizeLimbusCompany/LocalizeLimbusCompany"
API_URL="https://api.github.com/repos/${REPO}/releases/latest"

AUTH_HEADER=()
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
	AUTH_HEADER=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
fi

echo "Fetching latest release info from ${REPO}..."
RELEASE_JSON=$(curl -sSL "${AUTH_HEADER[@]}" "${API_URL}") || {
	echo "Failed to fetch release info" >&2
	exit 1
}

if [[ -z "${RELEASE_JSON}" ]]; then
	echo "Empty response from GitHub API" >&2
	exit 1
fi

# Pick asset whose name starts with LimbusLocalize and ends with .zip
if ! command -v jq >/dev/null 2>&1; then
	echo "jq is required to parse GitHub API response" >&2
	exit 1
fi

DOWNLOAD_URL=$(printf '%s\n' "${RELEASE_JSON}" | jq -r '.assets[]? | select((.name // "") | startswith("LimbusLocalize") and endswith(".zip")) | .browser_download_url' | head -n 1)

if [[ -z "${DOWNLOAD_URL}" ]]; then
	echo "No asset starting with 'LimbusLocalize' and ending with '.zip' found in latest release" >&2
	exit 1
fi

mkdir -p import

FILENAME=$(basename "${DOWNLOAD_URL}")
DEST_PATH="import/${FILENAME}"

echo "Downloading ${FILENAME} to ${DEST_PATH}..."
curl -L "${DOWNLOAD_URL}" -o "${DEST_PATH}"

if [[ $? -ne 0 ]]; then
	echo "Download failed" >&2
	exit 1
fi

echo "Unzipping ${DEST_PATH} into import/ ..."
unzip -o "${DEST_PATH}" -d import/

echo "Done."

