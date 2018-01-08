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

.PHONY: ha-floorplan
ha-floorplan:
	install ha-floorplan/panels/floorplan.html -Dt panels/
	install ha-floorplan/www/custom_ui/floorplan/floorplan.css -Dt www/custom_ui/floorplan/
	install ha-floorplan/www/custom_ui/floorplan/ha-floorplan.html -Dt www/custom_ui/floorplan/
	install ha-floorplan/www/custom_ui/floorplan/lib/jquery-3.2.1.min.js -Dt www/custom_ui/floorplan/lib/
	install ha-floorplan/www/custom_ui/floorplan/lib/svg-pan-zoom.min.js -Dt www/custom_ui/floorplan/lib/
	install ha-floorplan/www/custom_ui/floorplan/lib/moment.min.js -Dt www/custom_ui/floorplan/lib/

