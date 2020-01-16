install:
	docker build . -t tak0kada/conda-docker-env
	chmod 755 ./dconda
	mkdir -p ~/bin/
	cp ./dconda ~/bin/

clean:
	docker image rm tak0kada/conda-docker-env
	rm ~/bin/dconda
