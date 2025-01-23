#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

apt update && apt upgrade -y

apt install -y ubuntu-advantage-tools
pro enable usg
apt install -y usg
