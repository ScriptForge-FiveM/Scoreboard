fx_version 'cerulean'
games {'gta5'}

author 'ForgeScript - PatataTurchina'
description 'Advanced Scoreboard'
version '1.0.0'

client_scripts {
    'client/client.lua',
}
server_script {
    '@mysql-async/lib/MySQL.lua',
    'Server/server.lua'
}

shared_script {
    'config.lua'
}

ui_page 'html/build/index.html'

files {
    'html/build/index.html',
    'html/build/static/css/*.css',
    'html/build/static/js/*.js'
}
