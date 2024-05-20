fx_version 'cerulean'
game 'gta5'
author 'Cyrix'
description 'C-Breathalyzer'
version '1.1'

client_scripts {
    'client/*.lua'
}
server_scripts {
    'server/*.lua'
}
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

lua54 'yes'