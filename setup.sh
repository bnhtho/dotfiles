#!/bin/bash

#-- ╔═══════════════════════╗
#-- ║    System Detection   ║
#-- ╚═══════════════════════╝
# Detect the operating system
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "Detected platform: ${machine}"

#-- ╔═══════════════════════╗
#-- ║    Dynamic User Setup ║
#-- ╚═══════════════════════╝
current_user=$(whoami)
home_dir=$(eval echo "~${current_user}")
echo "Current user: ${current_user}"
echo "Home directory: ${home_dir}"


#-- ╔═══════════════════════╗
#-- ║ Step 0: Platform      ║
#-- ╚═══════════════════════╝
if [ "$machine" == "Mac" ]; then
    echo "Running on macOS"
elif [ "$machine" == "Linux" ]; then
    echo "Running on Linux"
fi
