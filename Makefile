.PHONY: tags *.yaml

%.test: %.yaml
	hass -c . --script check_config -i $^

tags:
	ctags --exclude=tags --language-force=hass --hass-kinds=Dr -R

all-tags:
	ctags --exclude=tags --language-force=hass --hass-kinds=Ddr -R

check:
	hass -c . --script=check_config

subscribe:
	mosquitto_sub -h localhost -v -t '#'
