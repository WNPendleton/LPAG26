class_name DirectionalLight
extends DirectionalLight3D

enum presets {SUN, MOON, INSIDE}

var current_preset = presets.SUN

var sun_color = Color(1.0, 1.0, 1.0, 1.0)
var sun_energy = 1.0

var moon_color = Color(0.792, 0.929, 1.0, 1.0)
var moon_energy = 0.1

var inside_energy = 0.0


func _ready() -> void:
	GlobalReferences.directional_light = self


func set_preset(preset):
	current_preset = preset
	if current_preset == presets.SUN:
		light_color = sun_color
		light_energy = sun_energy
	if current_preset == presets.MOON:
		light_color = moon_color
		light_energy = moon_energy
