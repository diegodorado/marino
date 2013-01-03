db = MongoMapper.database
collection = db.collection('fs.chunks')
collection.ensure_index([['files_id', Mongo::ASCENDING], ['n', Mongo::ASCENDING]], :unique => true) 

