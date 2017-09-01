deps:
	-git clone -q git@github.com:streetturtle/awesome-wm-widgets.git
	-git clone -q git@github.com:pltanton/net_widgets.git
	-git clone https://gist.github.com/fa6258f3ff7b17747ee3.git spotify-script
	cd spotify-script
	chmod +x sp
	sudo cp ./sp /usr/local/bin/
	rm -rf spotify-script
