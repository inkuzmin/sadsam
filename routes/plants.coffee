mongodb = require 'mongodb'
server      = new mongodb.Server "127.0.0.1", 27017, {}
db = new mongodb.Db 'test', server,
  safe: false
  native_parser: true

BSON = mongodb.BSONPure


_ = require 'underscore'

_.intersectionObjects = (array) ->
    slice = Array.prototype.slice
    rest = slice.call arguments, 1
    _.filter _.uniq(array), (item) ->
        _.every rest, (other) ->
            _.any other, (element) ->
                _.isEqual element, item

exports.getById = (req, res) ->
    db.open ( error, client ) ->
        client.collection 'plants', (error, collection) ->
            collection.find(
                    "_id": new BSON.ObjectID req.params.id
            ).toArray (error, docs) ->
                res.send docs[0]
                db.close()

exports.random = (req, res) ->
    db.open ( error, client ) ->
        client.collection 'plants', (error, collection) ->
            collection.count (error, total)->
                rand = Math.floor((Math.random()*total)-1)
                collection.find().limit(4).skip(rand).toArray (error, docs) ->
                    res.send docs
                    db.close()

                # find().limit(4).skip(2).next() Math.floor((Math.random()*10)+1);

exports.findAll = (req, res) ->
    db.open ( error, client ) ->
        client.collection 'plants', (error, collection) ->
            collection.find( ).toArray (error, docs) ->
                res.send docs
                db.close()

exports.findWithPrizeUpTo = (req, res) ->
    db.open ( error, client ) ->
        client.collection 'plants', (error, collection) ->
            collection.find(
                "prize":
                    "$lte": +req.params.prize
            ).toArray (error, docs) ->
                res.send docs
                db.close()

exports.findWithHightUpTo = (req, res) ->
    db.open ( error, client ) ->
        client.collection 'plants', (error, collection) ->
            collection.find(
                "height":
                    "$lte": +req.params.height
            ).toArray (error, docs) ->
                res.send docs
                db.close()

exports.filterByType = (req, res) ->
    db.open ( error, client ) ->
        client.collection 'plants', (error, collection) ->
            collection.find(
                "type": req.params.type
            ).toArray (error, docs) ->
                res.send docs
                db.close()

exports.filterBySource = (req, res) ->
    db.open ( error, client ) ->
        client.collection 'plants', (error, collection) ->
            collection.find(
                "source": req.params.source
            ).toArray (error, docs) ->
                res.send docs
                db.close()

exports.filterByAll = (req, res) ->
    if req.params.type != '*'
        type = req.params.type.split("&")

        search =    
                    "type":
                        "$in": type
                    "prize":
                        "$lte": +req.params.prize
                    "height":
                        "$lte": +req.params.height
    else
        search =    
                    "prize":
                        "$lte": +req.params.prize
                    "height":
                        "$lte": +req.params.height




    db.open ( error, client ) ->
        client.collection 'plants', (error, collection) ->
            collection.find(
                search
            ).toArray (error, docs) ->
                res.send docs
                db.close()

exports.search = (req, res) ->
    original = req.params.text
    capital  = original.toLowerCase().replace /(^|\s)(.)/g, (x) ->
        x.toUpperCase()
    general = original + " " + capital
    console.log general
    results = [] 
    db.open ( error, client ) ->
        client.command(
            {text: "plants", search: general, language: "russian"},
            (error, result) ->
                _.each result.results, (item) ->
                    results.push item.obj
                res.send results
                db.close()     
        )

exports.searchAndFilter = (req, res) ->
    resultFilter = []

    if req.params.type != '*'
        type = req.params.type.split("&")

        search =    
                    "type":
                        "$in": type
                    "prize":
                        "$lte": +req.params.prize
                    "height":
                        "$lte": +req.params.height
    else
        search =    
                    "prize":
                        "$lte": +req.params.prize
                    "height":
                        "$lte": +req.params.height

    db.open ( error, client ) ->
        client.collection 'plants', (error, collection) ->
            collection.find(
                search
            ).toArray (error, docs) ->
                resultFilter = docs
                db.close()
                
                resultSearch = []
                original = req.params.text
                capital  = original.toLowerCase().replace /(^|\s)(.)/g, (x) ->
                    x.toUpperCase()
                console.log original
                general = original + " " + capital

                db.open ( error, client ) ->
                    client.command(
                        {text: "plants", search: general, language: "russian"},
                        (error, result) ->
                            console.log result
                            _.each result.results, (item) ->
                                resultSearch.push item.obj
                            console.log resultFilter
                            console.log resultSearch
                            results = _.intersectionObjects(resultSearch, resultFilter)

                            res.send results
                            db.close()     
                    )




