class_name UISelectable
extends Node2D

@export var up: UISelectable
@export var down: UISelectable
@export var left: UISelectable
@export var right: UISelectable
@export var trigger: Trigger

var focused = false


func focus():
	focused = true
	$Circle.mesh.radius = 60
	$Circle.mesh.height = 120
	$Circle/Outline.mesh.radius = 70
	$Circle/Outline.mesh.height = 140


func unfocus():
	focused = false
	$Circle.mesh.radius = 50
	$Circle.mesh.height = 100
	$Circle/Outline.mesh.radius = 60
	$Circle/Outline.mesh.height = 120


func select():
	if trigger is Trigger:
		trigger.trigger()
