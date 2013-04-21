util	= require "util"
http	= require "http"

class CouchConnection
	constructor: ( @base_url, @database ) ->
		return 

	_make_request: ( path, cb ) ->
		_req	= http.request @base_url + path, ( res ) ->
			_response	= ""
			res.on "data", ( chunk ) ->
				_response = _response + chunk
			res.on "end", ( ) ->
				cb null, JSON.parse _response
			res.on "error", ( err ) ->
				cb err
		_req.end( )

	list_databases: ( cb ) ->
		@_make_request "/_all_dbs", cb


module.exports.CouchConnection = CouchConnection
