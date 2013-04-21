util	= require "util"
http	= require "http"

class CouchConnection
	constructor: ( @database_url ) ->

	_make_request: ( path, cb ) ->
		_req	= http.request @database_url + path, ( res ) ->
			_response	= ""
			res.on "data", ( chunk ) ->
				_response = _response + chunk
			res.on "end", ( ) ->
				cb null, JSON.parse _response
			res.on "error", ( err ) ->
				cb err
		_req.end( )
	
	get: ( id, cb ) ->
		@_make_request "/" + id, cb

module.exports.CouchConnection = CouchConnection
