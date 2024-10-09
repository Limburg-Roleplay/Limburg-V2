shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
--- DPEmotes by andristum ---
--- Forked by TayMcKenzieNZ ---
--- Check for updates at https://github.com/TayMcKenzieNZ/dpemotes ---
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
-- Remove the following lines if you would like to use the SQL keybinds. Requires oxmysql.
--#region oxmysql
-- dependency 'oxmysql'
-- server_script '@oxmysql/lib/MySQL.lua'
--#endregion oxmysql
shared_scripts {
    'config.lua',
}
server_scripts {
    'server/main.lua',
}
client_scripts {
    'NativeUI.lua',
    'client/AnimationList.lua',
    'client/AnimationListCustom.lua',
    'client/Emote.lua',
    'client/EmoteMenu.lua',
    'client/Keybinds.lua',
    'client/Ragdoll.lua',
    'client/Syncing.lua',
    'client/Walk.lua',
    'client/frameworks/*.lua'
}
data_file 'DLC_ITYP_REQUEST' 'badge1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'copbadge.ytyp'
data_file 'DLC_ITYP_REQUEST' 'prideprops_ytyp'
data_file 'DLC_ITYP_REQUEST' 'lilflags_ytyp'
data_file 'DLC_ITYP_REQUEST' 'bzzz_foodpack'
data_file 'DLC_ITYP_REQUEST' 'bzzz_prop_torch_fire001.ytyp'
data_file 'DLC_ITYP_REQUEST' 'natty_props_lollipops.ytyp'
data_file 'DLC_ITYP_REQUEST' 'apple_1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_food_icecream_pack.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_food_dessert_a.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/ultra_ringcase.ytyp'
