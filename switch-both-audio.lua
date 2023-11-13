--[[

An mpv script that allows switching between playing one or two audio tracks simultaneously upon file load or with a hotkey.

Note that the file must have exactly two audio tracks for this script to activate, otherwise the file will be ignored.
This script overrides user defiend `lavfi-complex` behavior.

To set a keybind, add `{key} script-message switch-both-audio` line to your `input.conf` e.g:

`n script-message switch-both-audio`

To switch the default state to "on" upon opening a file, create `switch_both_audio.conf` file in `portable_config/script-opts` directory
and add `enabled_on_start=yes` line to it.

--]]

require 'mp.options'
local mp = require 'mp'
local state = 'off'
local options = {
    enabled_on_start = false,
}
read_options(options,nil)

local function switch_on()
    mp.set_property('lavfi-complex', '[aid1] [aid2] amix [ao]')
    mp.set_property('aid','no')
    state = 'on'
end

local function switch_off()
    mp.set_property('lavfi-complex', '')
    mp.set_property_number('aid', 1)
    state = 'off'
end

local function switch_state()
    if state == 'off' then
        switch_on()
    elseif state == 'on' then
        switch_off()
    end
end

local function on_load()
    mp.unregister_script_message('switch-both-audio') -- prevent errors in mixed playlists by always disabling first
    local tracks_num = 0
    for _, track in pairs(mp.get_property_native('track-list')) do
        if track.type == 'audio' then
            tracks_num = tracks_num + 1
        end
    end

    if tracks_num == 2 then
        if options.enabled_on_start then
            switch_on()
        end
        mp.register_script_message('switch-both-audio', switch_state)
    end
end

mp.register_event('start-file', switch_off) -- prevent errors in mixed playlists by always disabling first
mp.register_event('file-loaded', on_load)
