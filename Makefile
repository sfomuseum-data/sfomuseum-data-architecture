CWD=$(shell pwd)

# https://github.com/whosonfirst/wof-cli
WOF_CLI=$(shell which wof)

# https://github.com/sfomuseum/go-geojson-show
SHOW=$(shell which show)

# https://github.com/whosonfirst/go-whosonfirst-exportify#wof-as-featurecollection
AS_FEATURECOLLECTION=$(shell which wof-as-featurecollection)

# https://github.com/whosonfirst/go-whosonfirst-exportify#wof-merge-featurecollection
MERGE_FEATURECOLLECTION=$(shell which wof-merge-featurecollection)

current:
	rm -f work/export-*.geojson
	@make buildings
	@make terminals
	@make boardingareas
	@make commonareas
	@make galleries
	@make gates

buildings:
	@make export-current PLACETYPE=building

terminals:
	@make export-current PLACETYPE=terminal

commonareas:
	@make export-current PLACETYPE=commonarea

boardingareas:
	@make export-current PLACETYPE=boardingarea

galleries:
	@make export-current PLACETYPE=gallery

gates:
	@make export-current PLACETYPE=gate

export-current:
	mkdir -p work
	$(WOF_CLI) emit \
		-iterator-uri 'repo://?include=properties.sfomuseum:placetype=$(PLACETYPE)&include=properties.mz:is_current=1' \
		-writer-uri 'featurecollection://?writer=stdout://' \
		$(CWD) > work/export-$(PLACETYPE).geojson

update-galleries-geoms:
	$(MERGE_FEATURECOLLECTION) -reader-uri repo://$(CWD) -writer-uri repo://$(CWD) -path geometry work/galleries.geojson

show:
	$(SHOW) \
		-point-style '{"color":"red","custom":{"color_map":{"key":{"-1":{"color":"#ccc","opacity":1},"0":{"color":"#000","opacity":1},"1":{"color":"white","opacity":1}},"property":"mz:is_current"},"fill_map":{"key":{"1":{"color":"orange","opacity":0.5},"2":{"color":"blue","opacity":0.5},"3":{"color":"green","opacity":0.5}},"property":"sfo:level"},"x_pane_map":{"key":{"*":"not_current","1":"is_current"},"property":"mz:is_current"}},"fillColor":"orange","radius":10}' \
		-label wof:name \
		-label sfo:level \
		-label mz:is_current \
		-label edtf:inception \
		-label edtf:cessation \
		-pane is_current=1000 \
		-pane not_current=500 \
		$(DATA)
