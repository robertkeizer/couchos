util	= require "util"
fs	= require "fs"
couchos	= require "./couchos"

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

		couch_connection	= new couchos.CouchConnection configuration["db_url_base"]
		util.log couch_connection.list_databases( )
