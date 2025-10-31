#!/data/data/com.termux/files/usr/bin/bash

# Directory Guard Firewall Script
# Usage: ./dir_guard.sh <directory>

TARGET_DIR="$1"

if [ -z "$TARGET_DIR" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
  echo "Directory not found: $TARGET_DIR"
  exit 1
fi

echo "Securing directory: $TARGET_DIR"

# Step 1: Restrict access to parent directories
echo "Locking parent directories..."
chmod -R o-rwx "$(dirname "$TARGET_DIR")"

# Step 2: Set restrictive permissions on sibling directories
echo "Blocking sibling access..."
for sibling in "$(dirname "$TARGET_DIR")"/*; do
  if [ "$sibling" != "$TARGET_DIR" ]; then
    chmod -R o-rwx "$sibling"
  fi
done

# Step 3: Apply strict permissions to the target directory
echo "Securing target directory..."
chmod -R 700 "$TARGET_DIR"

# Step 4: Optional — create a chroot-like jail (requires root)
# echo "Creating sandbox jail (requires root)..."
# chroot "$TARGET_DIR" /bin/bash

echo "Directory firewall active. External access blocked beyond: $TARGET_DIR"
