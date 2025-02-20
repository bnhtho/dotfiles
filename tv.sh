VER=`curl -s "https://api.github.com/repos/alexpasmantier/television/releases/latest" | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/'`
echo $VER
curl -LO https://github.com/alexpasmantier/television/releases/download/$VER/tv-$VER-macos-x86_64.tar.gz
