#!/usr/bin/env bash

set -e



function infinite_loop() {
  # Handle shutdown behavior
  trap 'shutdown_wg "$1"' SIGTERM SIGINT SIGQUIT

  sleep infinity &
  wait $!
}

function shutdown_wg() {
  echo "Shutting down Wireguard (boringtun)"
  wg-quick down "$1"
  exit 0
}

function start_wg() {
  echo "Starting up Wireguard (boringtun)"
  wg-quick up "$1"
  infinite_loop "$1"
}

function create_config() {
  cat /wg0.conf.template | envsubst > /etc/wireguard/wg0.conf
  cat /etc/wireguard/wg0.conf
}

create_config 
start_wg wg0


