CWD=$(shell pwd)

# https://github.com/whosonfirst/go-whosonfirst-exportify#wof-as-featurecollection
AS_FEATURECOLLECTION=$(shell which wof-as-featurecollection)

# https://github.com/whosonfirst/go-whosonfirst-exportify#wof-merge-featurecollection
MERGE_FEATURECOLLECTION=$(shell which wof-merge-featurecollection)

# Dump current galleries to a GeoJSON FeatureCollection
current-galleries:
	$(AS_FEATURECOLLECTION) -iterator-uri 'repo://?include=properties.sfomuseum:placetype=gallery&include=properties.mz:is_current=1' $(CWD) > work/galleries.geojson

update-galleries-geoms:
	$(MERGE_FEATURECOLLECTION) -reader-uri repo://$(CWD) -writer-uri repo://$(CWD) -path geometry work/galleries.geojson
