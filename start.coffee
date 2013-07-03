utils	= require "./utils"
util	= require "util"
fs	= require "fs"
vm	= require "vm"
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

			return cb null, config, res
	] , ( err, config, startup_doc ) ->
		if err
			utils.debug "Unable to startup."
			utils.debug err
			utils.fail "Dying."

		# Generate a context that we will run the code in..
		vm_context	= vm.createContext { "require": require, "config": config, "utils": utils, "me": startup_doc }

		# Run the code..
		try
			result = vm.runInContext startup_doc.code, vm_context
		catch err
			utils.debug "Got an error when executing the startup"
			utils.debug err
			utils.fail "Exiting."
		
		utils.debug "Dumping the result.."
		utils.debug result
