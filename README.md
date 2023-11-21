# mpv-switch-both-audio
An mpv script that allows switching between playing one or two audio tracks simultaneously upon file load or with a hotkey.

Note that the file must have exactly two audio tracks for this script to activate, otherwise the file will be ignored.
This script overrides user defined `lavfi-complex` behavior.

## Add a keybind
To set a keybind, add `{key} script-message switch-both-audio` line to your `input.conf` e.g:

`n script-message switch-both-audio`

## Default state
To switch the default state to "on" upon opening a file, create `switch_both_audio.conf` file in `portable_config/script-opts` directory
and add `enabled_on_start=yes` line to it.
