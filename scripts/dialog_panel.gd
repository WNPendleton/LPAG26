class_name DialogPanel
extends Panel

@onready var label = get_node("Label")
@onready var screen_change_time = 50.0 / text_speed

@export var text_speed = 40.0


func _ready():
	hide()


func display(display_text):
	var tween = get_tree().create_tween()
	for dialog_line in display_text:
		tween.tween_callback(func set_text(): label.text = dialog_line)
		tween.tween_callback(func set_ratio(): label.visible_ratio = 0.0)
		tween.tween_callback(func play_text_sound(): Wwise.post_event("Play_Text_Scroll", self))
		tween.tween_property(label, "visible_ratio", 1.0, dialog_line.length() / text_speed)
		tween.tween_callback(func stop_text_sound(): Wwise.post_event("Stop_Text_Scroll", self))
		tween.tween_callback(func delay(): pass).set_delay(screen_change_time)
	tween.tween_callback(hide)
	show()
	
