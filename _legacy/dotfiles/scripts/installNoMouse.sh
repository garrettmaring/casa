set -o errexit
set -o pipefail
set -o nounset

# Install
git clone https://github.com/brhs/nomouse
make -C nomouse
wait

# Add to user bin
mv nomouse/bin/nomouse "$HOME/bin"

# Clean up
trash nomouse
