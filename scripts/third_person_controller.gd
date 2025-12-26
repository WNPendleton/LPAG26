extends Node

const WALKING_THRESHOLD = 0.1
const RUNNING_THRESHOLD = 5.1
const HALF_PI = PI / 2.0
const THIRD_PI = PI / 3.0
const SIXTH_PI = PI / 6.0

@onready var dash_timer: Timer = Timer.new()
@onready var camera: Camera3D = GlobalReferences.gameplay_camera

@export var foot_speed = 7.0
@export var jump_distance = 5.0
@export var jump_height = 2.1
@export var land_assist_gravity_multiplier = 0.5
@export var terminal_velocity = 15.0
@export var acceleration = 20.0
@export var deceleration = 40.0
@export var turn_speed = 60.0
@export var air_acceleration = 10.0
@export var air_deceleration = 20.0
@export var air_turn_speed = 30.0
@export var coyote_time = 0.1
@export var jump_buffer_time = 0.05
@export var dash_distance = 5.0
@export var dash_speed = 15.0
@export var throw_power = 5.0
@export var character: CharacterBody3D
@export var interaction_area: Area3D
@export var carry_point: Node3D
@export var ledge_raycasts: Node3D
@export var animation_tree: AnimationTree
@export var skeleton: Skeleton3D
@export var character_audio: PlayerCharacterAudio

# NOTE: gravity and jump_velocity are defined here as functions of foot_speed,
# jump_distance and jump_height. This guarantees that the single jump will
# reach the specified height, and cross the specified distance at full speed
# for more information please watch https://www.youtube.com/watch?v=hG9SzQxaCm8
var gravity = 8 * jump_height * pow(foot_speed, 2) / pow(jump_distance, 2)
var jump_velocity = 4 * jump_height * foot_speed / jump_distance
var dash_duration = dash_distance / dash_speed
var interactables: Array
var focused_interactable = null
var carried_object = null
var has_double_jump = false
var has_dash = true
var time_off_floor = INF
var jump_buffer_timer = INF
var just_jumped = false
var just_air_jumped = false
var in_air = false
var anim = "idle"
var velocity: Vector3
var dashing = false
var ledge_step_lower: RayCast3D
var ledge_step_upper: RayCast3D

# TODO Maybes: wall running/jumping, ledge vaulting, grapple hook


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	dash_timer.one_shot = true
	add_child(dash_timer)
	dash_timer.connect("timeout", end_dash)
	if is_instance_valid(ledge_raycasts):
		ledge_step_lower = ledge_raycasts.get_node_or_null("LedgeStepLower")
		ledge_step_upper = ledge_raycasts.get_node_or_null("LedgeStepUpper")
		if not is_instance_valid(ledge_step_lower) or not is_instance_valid(ledge_step_upper):
			push_warning("Missing ledge step raycasts for player character controller" + str(get_path()))


func _physics_process(delta):
	update_start_of_frame_movement_vars(delta)
	handle_gravity_and_ground_checks(delta)
	handle_jump_inputs()
	handle_dash_inputs()
	handle_directional_inputs(delta)
	update_focused_interactable()
	handle_interaction_inputs()
	apply_movement()
	apply_rotation()
	update_carry_point_location()
	update_animation()


func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body is Interactable:
		interactables.append(body)


func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body is Interactable:
		interactables.erase(body)


func on_coyote_floor() -> bool:
	return character.is_on_floor() or time_off_floor < coyote_time


func update_start_of_frame_movement_vars(delta):
	velocity = character.velocity
	time_off_floor += delta
	jump_buffer_timer += delta
	just_jumped = false
	just_air_jumped = false


func update_carry_point_location():
	var bt1: Transform3D = skeleton.get_bone_global_pose(skeleton.find_bone("mixamorig_LeftHand"))
	var bt2: Transform3D = skeleton.get_bone_global_pose(skeleton.find_bone("mixamorig_RightHand"))
	var st: Transform3D = skeleton.global_transform
	var pos1: Vector3 = (st * bt1).origin
	var pos2: Vector3 = (st * bt2).origin
	carry_point.global_position = (pos1 + pos2) / 2.0


func handle_gravity_and_ground_checks(delta):
	if dashing:
		return
	var ascending = velocity.y > 0
	if Input.is_action_just_released("jump") and ascending:
		velocity.y *= 0.5
	if not character.is_on_floor():
		if ascending:
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * land_assist_gravity_multiplier * delta
	else:
		if time_off_floor > delta:
			character_audio.post_landing()
		time_off_floor = 0.0
		has_double_jump = true
		has_dash = true
	if velocity.y < -terminal_velocity:
		velocity.y = -terminal_velocity


func handle_jump_inputs():
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = 0.0
	if jump_buffer_timer < jump_buffer_time and (on_coyote_floor() or (has_double_jump and carried_object == null)):
		jump_buffer_timer = INF
		velocity.y = jump_velocity
		if not on_coyote_floor():
			has_double_jump = false
		just_jumped = true
		time_off_floor = INF
		end_dash()
		character_audio.post_jump()


func handle_dash_inputs():
	if Input.is_action_just_pressed("dash") and has_dash:
		dash_timer.start(dash_duration)
		dashing = true
		has_dash = false
		var dir = -character.basis.z
		velocity = dir * dash_speed


func end_dash():
	dash_timer.stop()
	dashing = false


func update_focused_interactable():
	if focused_interactable != null:
		focused_interactable.disable_focus()
	var min_dist = INF
	var closest = null
	for interactable in interactables:
		if interactable is Node3D:
			var dist = interaction_area.global_position.distance_to(interactable.global_position)
			if dist < min_dist:
				closest = interactable
				min_dist = dist
	focused_interactable = closest
	if focused_interactable != null:
		focused_interactable.enable_focus()


func handle_interaction_inputs():
	if Input.is_action_just_pressed("interact"):
		if carried_object != null:
			if (not is_instance_valid(focused_interactable)) or focused_interactable is Carriable:
				carried_object.throw(velocity, throw_power)
				carried_object = null
			elif is_instance_valid(focused_interactable) and focused_interactable is not Carriable:
				focused_interactable.interact()
		elif is_instance_valid(focused_interactable):
			if focused_interactable is Carriable:
				if carried_object == null:
					carried_object = focused_interactable
					carried_object.pick_up(carry_point)
			else:
				focused_interactable.interact()


func handle_directional_inputs(delta):
	if dashing:
		return
	var camera_angle = Vector2(camera.basis.z.x, camera.basis.z.z).angle() - HALF_PI
	var input_dir = Input.get_vector("strafe-left", "strafe-right", "forward", "backward").rotated(camera_angle)
	var horizontal_velocity = Vector2(velocity.x, velocity.z)
	var on_floor = character.is_on_floor()
	var frame_accel = determine_frame_acceleration(on_floor, input_dir, horizontal_velocity)
	horizontal_velocity += frame_accel * delta
	if horizontal_velocity.length() < 0.5 and not input_dir:
		horizontal_velocity = Vector2.ZERO
	if horizontal_velocity.length() > foot_speed:
		horizontal_velocity = horizontal_velocity.normalized() * foot_speed
	velocity = Vector3(horizontal_velocity.x, velocity.y, horizontal_velocity.y)


func determine_frame_acceleration(on_floor: bool, input_dir: Vector2, horizontal_velocity: Vector2):
	var inputting = input_dir != Vector2.ZERO
	var turning = inputting and abs(horizontal_velocity.angle_to(input_dir)) > SIXTH_PI
	if inputting:
		if on_floor:
			if turning:
				return turn_speed * input_dir
			else:
				return acceleration * input_dir
		else:
			if turning:
				return air_turn_speed * input_dir
			else:
				return air_acceleration * input_dir
	else:
		if on_floor:
			return deceleration * -horizontal_velocity.normalized()
		else:
			return air_deceleration * -horizontal_velocity.normalized()


func apply_movement():
	character.velocity = velocity
	character.move_and_slide()


func apply_rotation():
	var horizontal_velocity = Vector2(velocity.x, -velocity.z)
	if horizontal_velocity.length() <= 0:
		return
	var velocity_direction = horizontal_velocity.normalized().angle() - HALF_PI
	character.basis = Basis().rotated(Vector3.UP, velocity_direction)


func update_animation():
	var on_floor = character.is_on_floor()
	animation_tree["parameters/carry_blend/blend_amount"] = 1.0 if carried_object != null else 0.0
	if just_jumped:
		if on_floor:
			anim = "jump"
		else:
			anim = "air_jump"
	elif not on_floor:
		anim = "air_idle"
	elif on_floor and velocity.length() < WALKING_THRESHOLD:
		anim = "idle"
	elif on_floor and velocity.length() < RUNNING_THRESHOLD:
		anim = "walk"
	elif on_floor and velocity.length() >= RUNNING_THRESHOLD:
		anim = "run"
