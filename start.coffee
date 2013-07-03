utils	= require "./utils"
util	= require "util"
fs	= require "fs"
async	= require "async"

config_file	= "config.json"

async.waterfall [ 
	( cb ) ->
		fs.exists config_file, ( exists ) ->
			if not exists
				return cb "Couldn't find config file."
			return cb( null, exists )
	, ( exists, cb ) ->
		fs.readFile config_file, ( err, data ) ->
			if err
				return cb err
			return cb( null, JSON.parse( data ) )
	, ( config, cb ) ->
		
		# Make a new couch connection.
		couch_connection	= new utils.CouchConnection config.db_url
		
		# Bootstrap into a startup program
		couch_connection.get config.startup, ( err, res ) ->

			if err
				return cb err

			utils.debug res
			return cb( ) 
	] , ( err, res ) ->
		if err
			utils.debug "Unable to startup."
			utils.debug err
			utils.fail err

		utils.debug "got here"
