extends Node3D

var consumers = {}


func _ready() -> void:
	GlobalReferences.music_sync = self


func _on_music_midi_event(data: Dictionary) -> void:
	if not consumers.get(data.midiEvent.byChan):
		return
	if data.midiEvent.byType == 144 or data.midiEvent.byType == 128:
		for consumer in consumers.get(data.midiEvent.byChan):
			consumer.midi_event(data.midiEvent)


func _on_music_music_sync_beat(data: Dictionary) -> void:
	if not consumers.get("beat"):
		return
	for consumer in consumers.get("beat"):
		consumer.beat_event(data)


func _on_music_music_sync_user_cue(data: Dictionary) -> void:
	if not consumers.get(data.pszUserCueName):
		return
	for consumer in consumers.get(data.pszUserCueName):
		consumer.cue_event(data.pszUserCueName)


func register_midi_consumer(consumer, channel):
	var array = consumers.get(channel)
	if array == null:
		array = []
	array.append(consumer)
	consumers.set(channel, array)


func clear_consumers():
	consumers = {}
