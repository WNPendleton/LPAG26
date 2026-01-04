class_name ChangeLevel
extends Trigger

@export var level_name: String


func trigger():
	GlobalReferences.world.change_level(level_name)
