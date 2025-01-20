## 0.Set Hostname
## [n][Update later] Rebuild
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
# split
if [ "$machine" == "Mac" ]; then
    # code for macOS platform        
    echo "Changing hostname to MacbookAir"
sudo scutil --set HostName MacbookAir
# End of MacOS Section
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # code for GNU/Linux platform
    	echo "Running on Linux/Ubuntu"
fi

echo "Running Build for NixOS"
nix run home-manager switch
