extends Node3D

@export_group("Channels")
## Wether this controller listens for beat events
@export var beat := false
## Midi channels on which this controller listens for midiEvents.
@export_flags("0", "1", "2", "3", "4", "5", "6", "7",
"8", "9", "10", "11", "12", "13", "14", "15", "16") var channels = 0
@export_category("Light Sync Instructions")
@export var instructions: Dictionary[String, LightSyncParameters] = {
	"Start" : LightSyncParameters.new()
}

var lights: Array[Light3D]
var sequence: Array[Light3D]
var previous_triggers: Array[Light3D]
var tweens = {}
var parameters: LightSyncParameters


func _ready():
	if not GlobalReferences.music_sync:
		push_warning("No music sync controller found for LightSyncController " + str(get_path))
		return
	for cue_name in instructions.keys():
		GlobalReferences.music_sync.register_midi_consumer(self, cue_name)
	if beat:
		GlobalReferences.music_sync.register_midi_consumer(self, "beat")
	for channel in range(16):
		if channels & 1 << channel:
			GlobalReferences.music_sync.register_midi_consumer(self, channel)
	initialize_parameters(instructions.get("Start"))


func midi_event(event):
	if event.byType == 144:
		for i in range(parameters.trigger_count):
			var light = get_light()
			light.light_color = parameters.colors.pick_random()
			var active_tween = tweens.get(light)
			if active_tween:
				active_tween.kill()
			var tween = get_tree().create_tween()
			tween.tween_property(light, "light_energy", parameters.energy_max, parameters.attack_duration)
			if parameters.sustain_mode == parameters.sustain_modes.STATIC:
				tween.tween_callback(func nothing(): pass).set_delay(parameters.sustain_duration)
				tween.tween_property(light, "light_energy", parameters.energy_min, parameters.decay_duration)
			tweens.set(light, tween)
	elif event.byType == 128 and parameters.sustain_mode == parameters.sustain_modes.MIDI:
		for i in range(parameters.trigger_count):
			var light = previous_triggers.pop_front()
			var active_tween = tweens.get(light)
			if active_tween:
				active_tween.kill()
			if light:
				var tween = get_tree().create_tween()
				tween.tween_property(light, "light_energy", parameters.energy_min, parameters.decay_duration)
				tweens.set(light, tween)


func beat_event(_data):
	for i in range(parameters.trigger_count):
			var light = get_light()
			light.light_color = parameters.colors.pick_random()
			var active_tween = tweens.get(light)
			if active_tween:
				active_tween.kill()
			var tween = get_tree().create_tween()
			tween.tween_property(light, "light_energy", parameters.energy_max, parameters.attack_duration)
			if parameters.sustain_mode == parameters.sustain_modes.STATIC:
				tween.tween_callback(func nothing(): pass).set_delay(parameters.sustain_duration)
				tween.tween_property(light, "light_energy", parameters.energy_min, parameters.decay_duration)
			tweens.set(light, tween)


func cue_event(sectionName):
	if instructions.get(sectionName):
		initialize_parameters(instructions.get(sectionName))


func initialize_parameters(params):
	parameters = params
	lights = []
	for child in get_children():
		if child is Light3D:
			child.light_energy = parameters.energy_min
			lights.append(child)
	sequence = lights.duplicate()
	if parameters.randomize_order:
		sequence.shuffle()


func get_light() -> Object:
	var light = null
	match parameters.trigger_mode:
		parameters.trigger_modes.SEQUENCE:
			light = sequence.pop_front()
			sequence.append(light)
		parameters.trigger_modes.RANDOM:
			light = lights.pick_random()
		parameters.trigger_modes.ROUND_ROBIN:
			light = sequence.pop_front()
			if sequence.size() <= 0:
				sequence = lights.duplicate()
				sequence.shuffle()
		_:
			push_warning("Unknown trigger mode in LightSyncController " + str(get_path))
	if light:
		previous_triggers.erase(light)
		previous_triggers.append(light)
	return light
