#!/usr/bin/env python

import mapzen.whosonfirst.utils
import mapzen.whosonfirst.export

import sys
import os
import pprint

if __name__ == "__main__":

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

        feature = mapzen.whosonfirst.utils.load(data, wofid)
        props = feature["properties"]
        wofid = props["wof:id"]
        name = props["wof:name"]
        
        print "UPDATE %s (%s)" % (wofid, name)

        for child_id in rels.get(wofid, []):
            update(child_id)
        
    update(1159157271)

            
