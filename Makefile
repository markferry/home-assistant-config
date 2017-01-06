.PHONY: tags *.yaml

%.test: %.yaml
	hass -c . --script check_config -i $^

tags:
	ctags --language-force=hass -R

check:
	hass -c . --script=check_config

subscribe:
	mosquitto_sub -h localhost -v -t '#'
