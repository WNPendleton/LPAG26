@tool
extends Node3D

@onready var platform1 = $StaticBody3D
@onready var platform2 = $StaticBody3D2

@export var gap_distance = 0.0


func _ready() -> void:
		platform1.position.x = (-gap_distance * 0.5)
		platform2.position.x = (gap_distance * 0.5)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		platform1.position.x = (-gap_distance * 0.5)
		platform2.position.x = (gap_distance * 0.5)
