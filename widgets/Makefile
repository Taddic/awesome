deps:
	-git clone -q git@github.com:streetturtle/awesome-wm-widgets.git awesome-wm-widgets
	-git clone https://gist.github.com/fa6258f3ff7b17747ee3.git spotify-script
	chmod 755 spotify-script/sp
	sudo cp spotify-script/sp /usr/local/bin/
	rm -rf spotify-script
	-git clone https://github.com/haikarainen/light.git
	cd ./light && sudo make && sudo make install
	rm -rf light/

clean:
	-rm -rf awesome-wm-widgets
	-rf -rf awesome-network-manager
	-rm -rf spotify-script
