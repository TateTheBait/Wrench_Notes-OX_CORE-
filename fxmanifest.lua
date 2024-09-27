fx_version 'bodacious'
game 'gta5'

description "Wrench Tuning Laptop"

client_scripts {
	'client.lua',
}

server_scripts {
   "server.lua",
}

shared_scripts { 
	'config.lua',
	'@ox_lib/init.lua'
}
files {
	"html/*.html",
	"html/*.js",
	"html/*.css",
    "html/*.png"
}

ui_page "html/index.html"

lua54 'yes'
server_scripts { '@mysql-async/lib/MySQL.lua' }