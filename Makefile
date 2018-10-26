CONFIG_FILE=configs/basic.conf

image:
	./src/imagecreator.sh $(CONFIG_FILE)

clean:
	rm -f image.img
