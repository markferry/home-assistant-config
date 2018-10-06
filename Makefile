.PHONY: tags *.yaml

%.test: %.yaml
	hass -c . --script check_config -i $^

tags:
	ctags --exclude=tags --language-force=hass --hass-kinds=D -R

all-tags:
	ctags --exclude=tags --language-force=hass --hass-kinds=Ddr -R

check:
	hass -c . --script=check_config

subscribe:
	mosquitto_sub -h localhost -v -t '#'

install-dasher: mqtt-dasher/config.yml
	scp mqtt-dasher/config.yml pi@pixie3:/etc/mqtt-dasher/config.yml

onkyo-version:
	onkyo --host ballroom-amp firmware-version=query
