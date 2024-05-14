#!/usr/bin/env bash
#
# Extracted from https://deb.nodesource.com/setup_18.x

export DEBIAN_FRONTEND=noninteractive
NODENAME="Node.js 18.x"
NODEREPO="node_18.x"

print_status() {
    echo
    echo "## $1"
    echo
}

bail() {
    echo 'Error executing command, exiting'
    exit 1
}

exec_cmd_nobail() {
    echo "+ $1"
    bash -c "$1"
}

exec_cmd() {
    exec_cmd_nobail "$1" || bail
}

DISTRO=$(lsb_release -c -s)

exec_cmd "curl -sLf -o /dev/null 'https://deb.nodesource.com/${NODEREPO}/dists/${DISTRO}/Release'"

print_status 'Adding the NodeSource signing key to your keyring...'
keyring='/usr/share/keyrings'
node_key_url="https://deb.nodesource.com/gpgkey/nodesource.gpg.key"
local_node_key="$keyring/nodesource.gpg"

exec_cmd "curl -s $node_key_url | gpg --dearmor | tee $local_node_key >/dev/null"

print_status "Creating apt sources list file for the NodeSource ${NODENAME} repo..."

exec_cmd "echo 'deb [signed-by=$local_node_key] https://deb.nodesource.com/${NODEREPO} ${DISTRO} main' > /etc/apt/sources.list.d/nodesource.list"
exec_cmd "echo 'deb-src [signed-by=$local_node_key] https://deb.nodesource.com/${NODEREPO} ${DISTRO} main' >> /etc/apt/sources.list.d/nodesource.list"

exec_cmd 'apt-get update'
