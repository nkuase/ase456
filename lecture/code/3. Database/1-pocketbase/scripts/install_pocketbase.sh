os=$(uname -s | tr '[:upper:]' '[:lower:]')
arch=$(uname -m)
if [[ "$arch" == "x86_64" ]]; then
  arch="amd64"
elif [[ "$arch" == "aarch64" || "$arch" == "arm64" ]]; then
  arch="arm64"
fi

latest=$(curl -s https://api.github.com/repos/pocketbase/pocketbase/releases/latest | grep -E '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
version=$(echo "$latest" | sed 's/^v//')

if [[ -z "$latest" ]]; then
  echo "Error: Could not fetch latest PocketBase version tag."
  exit 1
fi

url="https://github.com/pocketbase/pocketbase/releases/download/${latest}/pocketbase_${version}_${os}_${arch}.zip"
dest="$HOME/pocketbase.zip"

echo "Download from: $url"

# Download with error check
wget -O "$dest" "$url"
if [[ $? -ne 0 ]]; then
  echo "Error: Download failed. Check your internet connection and the URL: $url"
  exit 1
fi

# Verify that download succeeded and is not a 404 HTML file
if ! file "$dest" | grep -qi zip; then
  echo "Error: Downloaded file is not a valid zip file. The file may not exist at the specified URL:"
  echo "$url"
  rm -f "$dest"
  exit 1
fi

# Unzip with error checking
unzip -d "$HOME/pocketbase" "$dest"
if [[ $? -ne 0 ]]; then
  echo "Error: Unzipping failed. The file may not be a valid ZIP archive:"
  echo "$dest"
  rm -f "$dest"
  exit 1
fi

rm "$dest"
echo "PocketBase successfully downloaded and extracted to $HOME/pocketbase"
