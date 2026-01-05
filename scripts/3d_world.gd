extends Node3D

@export var level_name = "hub_level"

var level


func _ready() -> void:
	switch_level_node(level_name)
	GlobalReferences.world = self


func change_level(new_level_name):
	GlobalReferences.music_sync.clear_consumers()
	GlobalReferences.player_character.clear_inventory()
	ListenerTriggerControl.clear_listeners()
	GlobalReferences.screen_transition.cover_with_callback(switch_level_node.bind(new_level_name))

func switch_level_node(new_level_name):
	var level_prefab = load("res://scenes/" + new_level_name + ".tscn")
	if level_prefab is PackedScene:
		var new_level = level_prefab.instantiate()
		if is_instance_valid(level):
			level.queue_free()
		new_level.name = "Level"
		add_child(new_level)
		level = new_level
	GlobalReferences.screen_transition.reveal_after(1.0)
