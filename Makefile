.PHONY: tags *.yaml

HOST ?= ballroom-amp
MQTT_REMOTE_HOST ?= whalebarn.com
MQTT_LOCAL_HOST ?= localhost
HOSTNAME := $(shell hostname)

%.test: %.yaml
	hass -c . --script check_config -i $^

tags:
	ctags --exclude=tags --language-force=hass -R

check:
	hass -c . --script=check_config

subscribe:
	mosquitto_sub -R -h ${MQTT_LOCAL_HOST} -v -t '#'

owntracks:
	mosquitto_sub -u pixie -P ${PASS} -h ${MQTT_REMOTE_HOST} -p 8883 -i dev --cafile /etc/ssl/certs/ca-certificates.crt -t '#' -v

install-dasher: mqtt-dasher/config.yml
	scp mqtt-dasher/config.yml pi@pixie3:/etc/mqtt-dasher/config.yml

onkyo-version:
	onkyo --host ballroom-amp firmware-version=query

onkyo-power:
	onkyo --host "${HOST}" main.power=query zone2.power=query

onkyo-volume:
	onkyo --host "${HOST}" main.master-volume=query zone2.volume=query

onkyo-selector:
	onkyo --host "${HOST}" main.input-selector=query zone2.selector=query

.PHONY: ha-floorplan
ha-floorplan:
	install ha-floorplan/panels/floorplan.html -Dt panels/
	install ha-floorplan/www/custom_ui/floorplan/floorplan.css -Dt www/custom_ui/floorplan/
	install ha-floorplan/www/custom_ui/floorplan/ha-floorplan.html -Dt www/custom_ui/floorplan/
	install ha-floorplan/www/custom_ui/floorplan/lib/jquery-3.2.1.min.js -Dt www/custom_ui/floorplan/lib/
	install ha-floorplan/www/custom_ui/floorplan/lib/svg-pan-zoom.min.js -Dt www/custom_ui/floorplan/lib/
	install ha-floorplan/www/custom_ui/floorplan/lib/moment.min.js -Dt www/custom_ui/floorplan/lib/

