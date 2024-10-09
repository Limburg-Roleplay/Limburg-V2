shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'bodacious'
game 'gta5'

description 'chat management stuff'

ui_page 'html/index.html'

client_scripts {
	'@es_extended/locale.lua',
	'cl_chat.lua'
}

files {
	'html/webfonts/*.ttf',
	'html/webfonts/*.woff2',
	'html/css/*.css',
	'html/index.html',
	'html/config.default.js',
	'html/App.js',
	'html/Message.js',
	'html/Suggestions.js',
	'html/vendor/vue.2.3.3.min.js',
	'html/vendor/flexboxgrid.6.3.1.min.css',
	'html/vendor/animate.3.5.2.min.css',
	'html/vendor/latofonts.css',
	'html/vendor/fonts/LatoRegular.woff2',
	'html/vendor/fonts/LatoRegular2.woff2',
	'html/vendor/fonts/LatoLight2.woff2',
	'html/vendor/fonts/LatoLight.woff2',
	'html/vendor/fonts/LatoBold.woff2',
	'html/vendor/fonts/LatoBold2.woff2',
}
