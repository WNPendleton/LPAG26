class_name PlayerCharacterAnimation
extends Node

const WALKING_THRESHOLD = 0.1

@onready var character = get_parent()

@export var carry_point: Node3D
@export var animation_tree: AnimationTree
@export var skeleton: Skeleton3D

var anim := "idle"
var carrying := false
var horizontal_velocity := Vector2(0.0, 0.0)
var vertical_velocity := 0.0
var on_floor = true
var just_jumped = false


func _physics_process(_delta: float) -> void:
	update_carry_point_location()
	update_animation()


func update_carry_point_location():
	var bt1: Transform3D = skeleton.get_bone_global_pose(skeleton.find_bone("mixamorig_LeftHand"))
	var bt2: Transform3D = skeleton.get_bone_global_pose(skeleton.find_bone("mixamorig_RightHand"))
	var st: Transform3D = skeleton.global_transform
	var pos1: Vector3 = (st * bt1).origin
	var pos2: Vector3 = (st * bt2).origin
	carry_point.global_position = (pos1 + pos2) / 2.


func update_animation():
	horizontal_velocity = Vector2(character.velocity.x, character.velocity.z)
	vertical_velocity = character.velocity.y
	animation_tree["parameters/carry_blend/blend_amount"] = 1.0 if carrying else 0.0
	animation_tree["parameters/StateMachine/ground_anim/blend_position"] = horizontal_velocity.length()
	if just_jumped:
		if on_floor:
			anim = "jump"
		else:
			anim = "air_jump"
	on_floor = character.is_on_floor()
	if not just_jumped:
		if not on_floor:
			anim = "air_idle"
		elif horizontal_velocity.length() < WALKING_THRESHOLD:
			anim = "idle"
		else:
			anim = "walkrun"
	just_jumped = false
