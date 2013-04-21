util	= require "util"
http	= require "http"
events	= require "events"

class CouchConnection extends events.EventEmitter
	constructor: ( @base_url, @database ) ->
		return 

	_make_request: ( path, cb ) ->
		_req	= http.request @base_url + path, ( res ) ->
			_response	= ""
			res.on "data", ( chunk ) ->
				_response = _response + chunk
			res.on "end", ( ) ->
				cb null, _response
			res.on "error", ( err ) ->
				cb err
		_req.close

	list_databases: ( cb ) ->
		@_make_requests cb

	

module.exports.CouchConnection = CouchConnection
