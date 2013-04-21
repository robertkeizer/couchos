util	= require "util"
fs	= require "fs"
couchos	= require "./couchos"

fail = ( msg ) ->
	if msg
		util.log msg
	process.exit 1

fs.exists "config.json", ( config_exists ) ->

	# Helper config fail function.
	config_fail = ( msg ) ->
		_msg	= "Unable to load configuration file."
		if msg
			return fail _msg + " ( " + msg + " )"
		else
			return fail _msg

	if not config_exists
		return config_fail( )

	fs.readFile "config.json", ( err, data ) ->
		if err
			return config_fail err
		try
			configuration	= JSON.parse( data )
		catch err
			return config_fail( err )

		couch_connection	= new couchos.CouchConnection configuration["db_url_base"]
		couch_connection.list_databases ( err, dbs ) ->
			if err
				return fail "Unable to list databases.. " + err
			
			util.log util.inspect dbs
