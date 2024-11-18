CWD=$(shell pwd)

# https://github.com/whosonfirst/go-whosonfirst-exportify#wof-as-featurecollection
AS_FEATURECOLLECTION=$(shell which wof-as-featurecollection)

# https://github.com/whosonfirst/go-whosonfirst-exportify#wof-merge-featurecollection
MERGE_FEATURECOLLECTION=$(shell which wof-merge-featurecollection)

current:
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
	$(AS_FEATURECOLLECTION) \
		-iterator-uri 'repo://?include=properties.sfomuseum:placetype=$(PLACETYPE)&include=properties.mz:is_current=1' \
		$(CWD) > work/export-$(PLACETYPE).geojson

update-galleries-geoms:
	$(MERGE_FEATURECOLLECTION) -reader-uri repo://$(CWD) -writer-uri repo://$(CWD) -path geometry work/galleries.geojson
