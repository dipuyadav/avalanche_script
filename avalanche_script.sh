sudo apt update && sudo apt install -y lz4

# Step 2: Check if snapshot is already downloaded, if not, download and extract it
export SNAPSHOT_DIR="/data"
export SNAPSHOT_FILE="$SNAPSHOT_DIR/v1.4.5"

if [ !  "$SNAPSHOT_FILE" ]; then
    echo "Snapshot not found. Downloading and extracting..."
    wget -O - https://snapshots.bwarelabs.com/avalanche/mainnet/avalanche20250120.tar.lz4 | lz4 -d | tar -x
else
    echo "Snapshot already exists, skipping download."
fi

# Step 3: Download the avalanchego-installer script
cd /data
wget -nd -m https://raw.githubusercontent.com/ava-labs/avalanche-docs/master/scripts/avalanchego-installer.sh

# Step 4: Modify the installer script to allow running as root
FILE="/data/avalanchego-installer.sh"
sed -i '/^if ((EUID == 0)); then/,/^fi/s/^/#/' "$FILE"

# Step 5: Make the script executable
chmod 755 /data/avalanchego-installer.sh

# Step 6: Run the installer and automate inputs
/data/avalanchego-installer.sh <<EOF
1
y
public
yes
on
EOF


echo "Avalanche Node setup complete in /data directory."
