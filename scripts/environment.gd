class_name AmbientEnvironment
extends WorldEnvironment

enum presets {SUN, MOON}

@export var initial_preset: presets
@export var directional_lighting: DirectionalLight3D
@export var lightning: DirectionalLight3D
@export var music: AkEvent3D
@export var ambience: AkEvent3D

var current_preset = presets.SUN
var sun_color = Color(1.0, 1.0, 1.0, 1.0)
var sun_energy = 1.0
var moon_color = Color(0.792, 0.929, 1.0, 1.0)
var moon_energy = 0.1
var inside_energy = 0.0


func _ready() -> void:
	GlobalReferences.ambient_environment = self
	set_preset(initial_preset)
	music.post_event()
	ambience.post_event()


func set_preset(preset):
	current_preset = preset
	if current_preset == presets.SUN:
		directional_lighting.light_color = sun_color
		directional_lighting.light_energy = sun_energy
	if current_preset == presets.MOON:
		directional_lighting.light_color = moon_color
		directional_lighting.light_energy = moon_energy


func lightning_flash(energy: float = -1.0, duration: float = -1.0, direction := Vector3.ZERO):
	if direction == Vector3.ZERO:
		direction = Vector3(randf_range(-1, -30), randf_range(0, 360), 0)
	lightning.rotation_degrees = direction
	if energy < 0:
		energy = randf_range(1.0, 5.0)
	lightning.light_energy = energy
	if duration < 0:
		duration = randf_range(0.5, 1.5)
	var tween = get_tree().create_tween()
	tween.tween_property(lightning, "light_energy", 0.0, duration)


func _on_ambience_audio_marker(data: Dictionary) -> void:
	match data.strLabel:
		"lightning_1":
			lightning_flash(5.0)
		"lightning_2":
			lightning_flash(4.0)
		"lightning_3":
			lightning_flash(2.0)
		"lightning_4":
			lightning_flash(1.0)
		"lightning_5":
			lightning_flash(3.0)
		_:
			push_warning("Unknown Wwise callback received in AmbientEnvironment " + str(get_path))


func set_next_music(music_name):
	Wwise.set_state("Music_Selection", music_name)


func set_music_immediately(music_name):
	music.stop_event()
	Wwise.set_state("Music_Selection", music_name)
	music.post_event()


func set_next_ambience(ambience_name):
	Wwise.set_state("Ambience", ambience_name)


func set_ambience_immediately(ambience_name):
	ambience.stop_event()
	Wwise.set_state("Ambience", ambience_name)
	ambience.post_event()
