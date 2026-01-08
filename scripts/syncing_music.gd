extends AkEvent3D


func _ready() -> void:
	var music_sync_control = GlobalReferences.music_sync
	connect("midi_event", music_sync_control._on_music_midi_event)
	connect("music_sync_beat", music_sync_control._on_music_music_sync_beat)
	connect("music_sync_user_cue", music_sync_control._on_music_music_sync_user_cue)
	post_event()
