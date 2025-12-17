class_name DialogPanel
extends Panel

@onready var label = get_node("Label")

@export var text_speed = 40.0


func _ready():
	hide()


func display(display_text):
	var tween = get_tree().create_tween()
	for dialog_line in display_text:
		tween.tween_callback(func set_text(): label.text = dialog_line)
		tween.tween_callback(func set_ratio(): label.visible_ratio = 0.0)
		tween.tween_property(label, "visible_ratio", 1.0, dialog_line.length() / text_speed)
		tween.tween_callback(func delay(): pass).set_delay(2.0)
	tween.tween_callback(hide).set_delay(50.0 / text_speed)
	show()
	
