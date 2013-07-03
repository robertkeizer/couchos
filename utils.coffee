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
		@_make_request "/" + id, ( err, data ) ->
			if err
				return cb err

			if data["error"]?
				return cb data
	
			return cb null, data

module.exports.CouchConnection = CouchConnection

# Simple fatal error message.
module.exports.fail = ( msg ) ->
	util.log msg
	process.exit 1

module.exports.debug = ( _o ) ->
	util.log( util.inspect( _o ) )
