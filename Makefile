CWD=$(shell pwd)

# https://github.com/whosonfirst/go-whosonfirst-exportify#wof-as-featurecollection
AS_FEATURECOLLECTION=$(shell which wof-as-featurecollection)

galleries:
	@echo $(AS_FEATURECOLLECTION) -iterator-uri 'repo://?include=properties.sfomuseum:placetype=gallery&include=properties.mz:is_current=1' $(CWD)
