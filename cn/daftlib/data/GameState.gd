# Auto load by daftlib.gd

extends Node

# Opening Animation, Main menu, Credits etc.
const MAIN_MENU:String = "main_menu"
# Game in progress
const GAME_PLAYING:String = "game_playing"
# Transition between scenes
const TRANSITIONING:String = "transitioning"
# Loading, Saving, Waiting response
const DATA_FETCHING:String = "data_fetching"

const POPUP_MENU_OPENNING:String = "popup_menu_openning"
#const POPUP_SHOWING:String = "popup_showing"
const PAUSING:String = "pausing"

signal change(current:String, previous:String)

var _previous:String
var previous:String:
	get:
		return _previous
var _current:String
var current:String:
	get:
		return _current
	set(value):
		if _current != value:
			_previous = _current
			_current = value
			change.emit(_current, _previous)
