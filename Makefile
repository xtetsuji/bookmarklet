usage:
	@echo "Usage:"
	@echo "  make *.packd.js"

%.packed.js: %.js
	bin/js2let.js $< > $@

