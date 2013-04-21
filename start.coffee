util	= require "util"
fs	= require "fs"
couchos	= require "./couchos"

fail = ( msg ) ->
	if msg
		util.log msg
	process.exit 1

fs.exists "config.json", ( config_exists ) ->

	if not config_exists
		return fail "Couldn't find the config file."

	fs.readFile "config.json", ( err, data ) ->
		if err
			return fail err
		try
			configuration	= JSON.parse( data )
		catch err
			return fail err

		couch_connection	= new couchos.CouchConnection configuration["db_url"]
		
		couch_connection.get configuration["shell"], ( err, res ) ->

			if err
				return fail "Unable to find the shell '" + configuration["shell"] + "': " + err
			
			util.log util.inspect res
