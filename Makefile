.PHONY: tags
tags:
	ctags --language-force=hass -R

check:
	hass -c . --script=check_config
