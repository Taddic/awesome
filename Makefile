deps:
	-git clone -q git@github.com:streetturtle/awesome-wm-widgets.git
	-cd /usr/share/icons/Arc/status/symbolic && sudo cp audio-volume-muted-symbolic.svg audio-volume-muted-symbolic_red.svg && sudo sed -i 's/bebebe/ed4737/g' ./audio-volume-muted-symbolic_red.svg
	-git clone -q git@github.com:pltanton/net_widgets.git
	-git clone https://gist.github.com/fa6258f3ff7b17747ee3.git spotify-script
	-cd spotify-script && chmod +x ./sp && sudo cp ./sp /usr/local/bin/
	-rm -rf spotify-script
	-git clone https://github.com/haikarainen/light.git && cd ./light && sudo make && sudo make install
	-rm -rf light
