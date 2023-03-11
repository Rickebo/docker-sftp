#!/bin/bash
set -e

if [ -n "$MOUNT_DEVICE" ]; then
    echo "Mounting device /dev/$MOUNT_DEVICE"
    mkdir /mnt/$MOUNT_DEVICE
    chown remote:remote /mnt/$MOUNT_DEVICE
    mount /dev/$MOUNT_DEVICE /mnt/$MOUNT_DEVICE
    chmod 555 /mnt/$MOUNT_DEVICE
fi

if [ -n "$SSH_KEY" ]; then
    echo "Using ssh key from environment variable SSH_KEY..."
    mkdir /home/remote/.ssh
    chown remote:remote /home/remote/.ssh
    chmod 700 /home/remote/.ssh
    echo $SSH_KEY > /home/remote/.ssh/authorized_keys
    chmod 644 /home/remote/.ssh/authorized_keys
fi

if [ -n "$ROOT_DIR" ]; then
    echo "Using root directory $ROOT_DIR"
    find $ROOT_DIR -type d -exec chmod 755 {} \;
    find $ROOT_DIR -type d -exec chown remote:remote {} \;
    chown root:root $ROOT_DIR
    chmod 555 $ROOT_DIR

    mkdir -p $ROOT_DIR/bin
    chown root:root $ROOT_DIR/bin
    chmod -R 755 $ROOT_DIR/bin

    cp $(which md5sum) $ROOT_DIR/bin
    cp $(which sha1sum) $ROOT_DIR/bin
fi

exec /usr/sbin/sshd -D
