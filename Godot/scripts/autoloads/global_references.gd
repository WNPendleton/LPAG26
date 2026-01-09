extends Node

var player_character
var gameplay_camera
var ambient_environment
var music_sync
var world

var dialog_panel
var screen_transition
var level_select_panel

var god_mode = false


func _physics_process(_delta: float) -> void:
	if OS.is_debug_build() and Input.is_action_just_pressed("toggle_god_mode"):
		god_mode = not god_mode
