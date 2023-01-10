CWD=$(shell pwd)

# https://github.com/whosonfirst/go-whosonfirst-exportify#wof-as-featurecollection
AS_FEATURECOLLECTION=$(shell which wof-as-featurecollection)

# https://github.com/whosonfirst/go-whosonfirst-exportify#wof-merge-featurecollection
MERGE_FEATURECOLLECTION=$(shell which wof-merge-featurecollection)

galleries-level0:
	@make current-galleries LEVEL=0

galleries-level1:
	@make current-galleries LEVEL=1

galleries-level2:
	@make current-galleries LEVEL=2

galleries-level3:
	@make current-galleries LEVEL=3

galleries-level4:
	@make current-galleries LEVEL=4

current-galleries:
	$(AS_FEATURECOLLECTION) -iterator-uri 'repo://?include=properties.sfomuseum:placetype=gallery&include=properties.mz:is_current=1&include=properties.sfo:level=$(LEVEL)' $(CWD) > work/galleries-level$(LEVEL).geojson

current-gates:
	$(AS_FEATURECOLLECTION) -iterator-uri 'repo://?include=properties.sfomuseum:placetype=gate&include=properties.mz:is_current=1' $(CWD) > work/gates.geojson

update-galleries-geoms:
	$(MERGE_FEATURECOLLECTION) -reader-uri repo://$(CWD) -writer-uri repo://$(CWD) -path geometry work/galleries.geojson
