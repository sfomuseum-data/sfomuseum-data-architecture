CWD=$(shell pwd)

# https://github.com/whosonfirst/go-whosonfirst-exportify#wof-as-featurecollection
AS_FEATURECOLLECTION=$(shell which wof-as-featurecollection)

# https://github.com/whosonfirst/go-whosonfirst-exportify#wof-merge-featurecollection
MERGE_FEATURECOLLECTION=$(shell which wof-merge-featurecollection)

# Dump current galleries to a GeoJSON FeatureCollection
export-galleries:
	$(AS_FEATURECOLLECTION) -iterator-uri 'repo://?include=properties.sfomuseum:placetype=gallery&include=properties.mz:is_current=1' $(CWD) > work/galleries.geojson

update-galleries-geoms:
	$(MERGE_FEATURECOLLECTION) -reader-uri fs://$(CWD) -writer-uri fs://$(CWD) -path geometry $(FEATURECOLLECTION)
