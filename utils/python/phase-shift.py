#!/usr/bin/env python

import mapzen.whosonfirst.utils
import mapzen.whosonfirst.export

import sys
import os
import copy
import pprint

if __name__ == "__main__":

    sfo_id = 1159157271
    inception = "2019-07-23"
    
    arch = "/usr/local/data/sfomuseum-data-architecture"
    data = os.path.join(arch, "data")

    crawl = mapzen.whosonfirst.utils.crawl(data, inflate=True)
    rels = {}
    
    for feature in crawl:

        props = feature["properties"]
        wofid = props["wof:id"]
        parentid = props["wof:parent_id"]
        
        children = rels.get(parentid, [])
        children.append(wofid)

        rels[parentid] = children

    def update(wofid):

        old_feature = mapzen.whosonfirst.utils.load(data, wofid)
        old_props = old_feature["properties"]
        old_id = props["wof:id"]
        old_name = props["wof:name"]

        print "UPDATE %s (%s)" % (old_id, old_name)
        
        new_feature = copy.deepcopy(feature)
        new_props = new_feature["properties"]

        new_id = mapzen.whosonfirst.utils.generate_id()        
        new_props["wof:id"] = new_id
        new_props["edtf:inception"] = inception
        new_props["wof:supersedes"] = [ wofid ]

        new_feature["properties"] = new_props
        exporter.export_feature(new_feature)        

        old_props["edtf:cessation"] = inception
        old_props["mz:is_current"] = 0
        old_props["wof:superseded_by"] = [ new_id ]

        old_feature["properties"] = old_props
        exporter.export_feature(old_feature)
        
        for child_id in rels.get(wofid, []):
            update(child_id)
        
    update(sfo_id)

            
