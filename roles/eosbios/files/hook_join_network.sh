#!/bin/bash -e

# `join_network` hook:
# $1 = genesis_json
# $2 = p2p_address_statements like "p2p-peer-address = 1.2.3.4\np2p-peer-address=2.3.4.5"
# $3 = p2p_addresses to connect to, split by comma
# $4 = producer-name statements, like: "producer-name = hello\nproducer-name = hello.a"
#      You will have many only when joining a net with less than 21 producers.
# $5 = producer-name you should handle, split by comma


# WARN: this is SAMPLE keys configuration to get your keys into your config.
#       You'll want to adapt that to your infrastructure, `cat` it from a file,
#       use some secrets management software or whatnot.
#
#       They need to reflect your `target_initial_authority`
#       strucuture in your `my_discovery_file.yaml`.
#

echo "Removing old nodeos data (you might be asked for your sudo password)..."
sudo rm -rf /tmp/nodeos-data

echo "Writing genesis.json"
echo $1 > /data/genesis.json

# Your base_config.ini shouldn't contain any `producer-name` nor `private-key`
# nor `enable-stale-production` statements.
echo "Copying p2p peers"
echo "$2" >> /data/config.ini

echo "Running 'nodeos' through Docker."
docker start nodeos

echo ""
echo "   View logs with: docker logs -f nodeos-bios"
echo ""

echo "Waiting 3 secs for nodeos to launch through Docker"
sleep 3

echo "Hit ENTER to continue"
read
