DROP FUNCTION IF EXISTS manager.table2jsonset(text,text);
CREATE OR REPLACE FUNCTION manager.table2jsonset(filesystemdir text, tablename text)
    RETURNS text AS
$$
    import os
    import re
    import unicodedata 
    
    (tableschema,sep,tablenamesimple) = tablename.partition(".")

    #-- The json to build follows the rules on manager.labels
    retv00 = plpy.execute("select labels.column_name,labels.label,labels.position from information_schema.columns join manager.labels on columns.table_name = labels.table_name AND columns.column_name = labels.column_name where information_schema.columns.table_schema = '%s' and information_schema.columns.table_name = '%s' order by labels.position"%(tableschema,tablenamesimple))
    
    attributes2extract = ''
    for i in range(len(retv00)):
        attributes2extract += ','
        #-- if "tags" == str(retv00[i]["column_name"]):
        #--     attributes2extract += 'CASE WHEN 0 = array_length(hstore_to_array(tags),1) THEN null ELSE tags END'
        #--     #--attributes2extract += 'hstore_to_json_loose("' + str(retv00[i]["column_name"]) + '")'
        #-- else:
        attributes2extract += '"' + str(retv00[i]["column_name"]) + '"'
        attributes2extract += ' AS ' + '"' + str(retv00[i]["label"]) + '"'

    retv01 = plpy.execute("select label from manager.labels where labels.table_name = '%s' AND labels.column_name = '_table_name_'"%(tablenamesimple),1)
    
    tablelabel = tablename
    try:
        tablelabel = retv01[0]['label']
    except:
        pass

        
    counter = 0
    retv02 = plpy.execute("select t.id, row_to_json(t) as payload  FROM ( select '%s' AS table_name %s from %s ) t "%(tablelabel,attributes2extract,tablename));
    for i in range(len(retv02)):
        payload = unicodedata.normalize('NFC',retv02[i]["payload"])
        #-- hack for empty tags
        payload = payload.replace('"Tags":,','',1);
        #-- hack for putting tags to the root 
        payload = payload.replace('"Tags":{','',1);
        payload = payload.replace('},',',',1);
        payload = payload.replace(',,',',');
        id = retv02[i]["id"]
        #-- (subdir,sep,lastpart) = id.partition("-")
        subdir = id[0:3]
        filename = ""
        filename += filesystemdir + "/" + subdir + "/" + str(id) + ".json"
        if not os.path.exists(os.path.dirname(filename)):
            os.makedirs(os.path.dirname(filename))

        with open(filename, encoding='utf-8', mode="w") as f:
            f.write(payload)
            counter += 1
    
    return "ok - generated " + str(counter) + " json features"
$$
LANGUAGE plpython3u ;