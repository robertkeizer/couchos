util	= require "util"
fs	= require "fs"
http	= require "http"

fs.exists "config.json", ( config_exists ) ->

	# Helper config fail function.
	config_fail = ( msg ) ->
		_msg	= "Unable to load configuration file."
		if msg
			util.log _msg + " ( " + msg + " )"
		else
			util.log _msg

		process.exit 1

	if not config_exists
		return config_fail( )

	fs.readFile "config.json", ( err, data ) ->
		if err
			return config_fail err
		try
			configuration	= JSON.parse( data )
		catch err
			return config_fail( err )

		util.log util.inspect configuration
		# We now have the configuration variable to work with..
		req = http.request { "hostname": configuration["db"]["host"], "port": configuration["db"]["port"], "method": "GET", "path": "/_all_dbs" }, ( res ) ->
			_response = ""
			res.on "data", ( chunk ) ->
				_response = _response + chunk
			res.on "end", ( ) ->
				util.log util.inspect _response

		req.end( )
