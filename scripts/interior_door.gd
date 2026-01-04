class_name InteriorDoor
extends Node3D

const SPRING_WEIGHT = 5.0

@export var locked := false
@export var barrier: CSGPrimitive3D
@export var hinge: Node3D
@export var area: Area3D

var bodies = []
var rot = 0.0
var angular_velocity = 0.0


func _ready() -> void:
	if barrier:
		barrier.hide()
		barrier.use_collision = locked


func _physics_process(delta: float) -> void:
	if locked:
		return
	var min_vel = 0.0
	for body in bodies:
		var velocity_mult = 1.0
		if body.get("velocity"):
			velocity_mult = body.velocity.length()
			min_vel = max(min_vel, body.velocity.length())
		if body.get("linear_velocity"):
			velocity_mult = body.linear_velocity.length()
			min_vel= max(min_vel, body.linear_velocity.length())
		if body is Player:
			velocity_mult *= 5.0
		var displacement3 = body.global_position.direction_to(area.global_position)
		var displacement2 = Vector2(displacement3.x, displacement3.z)
		var facing2 = Vector2((-global_basis.z).x, (-global_basis.z).z)
		var swing_dir = -1 if abs(displacement2.angle_to(facing2)) > PI / 2.0 else 1
		angular_velocity += swing_dir * delta * velocity_mult
	if abs(angular_velocity) < min_vel:
		angular_velocity = min_vel * sign(angular_velocity)
	if abs(rot) > PI / 2.0:
		rot = clamp(rot, -PI / 2.0, PI / 2.0)
		angular_velocity = 0
	if abs(rot) > 0:
		angular_velocity -= rot * 5.0 * SPRING_WEIGHT * delta
	if abs(angular_velocity) > 0:
		angular_velocity -= sign(angular_velocity) * SPRING_WEIGHT * delta
	rot += angular_velocity * delta
	hinge.basis = Basis().rotated(Vector3.UP, rot)


func _on_area_body_entered(body: Node3D) -> void:
	if body is PhysicsBody3D:
		bodies.append(body)
	if body is Player:
		angular_velocity = 0.0


func _on_area_body_exited(body: Node3D) -> void:
	bodies.erase(body)


func unlock():
	locked = false
	barrier.use_collision = locked
