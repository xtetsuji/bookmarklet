usage:
	@echo "Usage:"
	@echo "  make *.packd.js"

%.packed.js: %.js
	@echo "$< to $@"
	bin/js2let.pl $< > $@

