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
    debug = False
    
    arch = "/usr/local/data/sfomuseum-data-architecture"
    data = os.path.join(arch, "data")

    wof_data = "/usr/local/data/sfomuseum-data-whosonfirst/data"
    
    crawl = mapzen.whosonfirst.utils.crawl(data, inflate=True)
    rels = {}
    
    for feature in crawl:

        props = feature["properties"]
        wofid = props["wof:id"]
        parentid = props["wof:parent_id"]
        
        children = rels.get(parentid, [])
        children.append(wofid)

        rels[parentid] = children

    def update(old_feature, parent):

        old_props = old_feature["properties"]
        old_id = old_props["wof:id"]
        old_name = old_props["wof:name"]
        old_placetype = old_props["sfomuseum:placetype"]
        
        old_props["edtf:cessation"] = inception
        old_props["mz:is_current"] = 0
        
        is_t1_child = False

        if old_placetype == "gate" and old_name.startswith("B"):
            is_t1_child = True

        if old_id in [ 1159157077, 1159157081 ]:
            is_t1_child = True

        print "UPDATE %s (%s, %s) is T1: %s" % (old_id, old_name, old_placetype, is_t1_child)
        
        if not is_t1_child:
        
            new_feature = copy.deepcopy(feature)
            new_props = new_feature["properties"]
        
            new_id = mapzen.whosonfirst.utils.generate_id()        
            new_props["wof:id"] = new_id

            new_props["edtf:inception"] = inception
            new_props["edtf:cessation"] = "open"
            new_props["mz:is_current"] = 1
            new_props["wof:supersedes"] = [ wofid ]

            parent_props = parent["properties"]
            new_props["wof:parent_id"] = parent_props["wof:id"]
            new_props["wof:hierarchy"] = parent_props["wof:hierarchy"]
            
            new_feature["properties"] = new_props

            if not debug:            
                exporter.export_feature(new_feature)        

            old_props["wof:superseded_by"] = [ new_id ]

        old_feature["properties"] = old_props

        if not debug:
            exporter.export_feature(old_feature)

        if not is_t1_child:
            
            for child_id in rels.get(old_id, []):
                child_feature = mapzen.whosonfirst.utils.load(data, child_id)            
                update(child_feature, new_feature)

    sfo = mapzen.whosonfirst.utils.load(data, sfo_id)
    parent = mapzen.whosonfirst.utils.load(wof_data, sfo["properties"]["wof:parent_id"])
    
    update(sfo, parent)

            
