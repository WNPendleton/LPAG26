extends Node

@export var SPEED = 5.0
@export var SPRINT_MULTIPLIER = 1.5
@export var JUMP_VELOCITY = 4.5
@export var LOOK_SPEED = 0.01
@export var max_rot_y = PI / 2
@export var character: CharacterBody3D
@export var pivot: Node3D

var rot_x = 0
var rot_y = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	if not is_instance_valid(pivot):
		push_error("Pivot (or camera) not provided for first person controller")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	var velocity = character.velocity
	if not character.is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir = Input.get_vector("strafe-left", "strafe-right", "forward", "backward")
	var direction = (character.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var sprint_mod = SPRINT_MULTIPLIER if Input.is_action_pressed("sprint") else 1.0
	if direction:
		velocity.x = direction.x * SPEED * sprint_mod
		velocity.z = direction.z * SPEED * sprint_mod
	else:
		velocity.x = 0
		velocity.z = 0
	var controller_look_dir = Input.get_vector("look-left", "look-right", "look-up", "look-down")
	apply_camera_rotation(controller_look_dir * 5.0)
	character.velocity = velocity
	character.move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		apply_camera_rotation(event.relative)


	# TODO: potential double-look-speed bug here if the player simultaneously uses both the mouse
	# and the controller but the camera sensitivity is probably a player-controlled setting by the
	# time we ship anyway so its probably fine
func apply_camera_rotation(relative: Vector2):
	rot_x += relative.x * LOOK_SPEED
	rot_x = fmod(rot_x, TAU)
	rot_y += relative.y * LOOK_SPEED
	rot_y = clamp(rot_y, -max_rot_y, max_rot_y)
	character.transform.basis = Basis().rotated(Vector3(0,-1,0), rot_x)
	pivot.transform.basis = Basis().rotated(Vector3(-1,0,0), rot_y)
