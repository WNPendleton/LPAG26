class_name DialogPanel
extends Panel

const ERR_MSG = ["{DIALOG_SYSTEM_ERROR}"]

@onready var label = get_node("Label")
@onready var screen_change_time = 50.0 / text_speed

@export var text_speed = 40.0

var dialog_dict


func _ready():
	hide()


func initiate_dialog_event(dialog_list, trigger = null):
	display(dialog_list, trigger)


func display(dialog_list, trigger):
	var tween = get_tree().create_tween()
	GlobalReferences.player_character.claim_input_lock(self)
	for dialog_line in dialog_list:
		var text = tr(dialog_line)
		tween.tween_callback(func set_text(): label.text = text)
		tween.tween_callback(func set_ratio(): label.visible_ratio = 0.0)
		tween.tween_callback(func play_text_sound(): Wwise.post_event("Play_Text_Scroll", self))
		tween.tween_property(label, "visible_ratio", 1.0, text.length() / text_speed)
		tween.tween_callback(func stop_text_sound(): Wwise.post_event("Stop_Text_Scroll", self))
		tween.tween_callback(func delay(): pass).set_delay(screen_change_time)
	tween.tween_callback(hide)
	if trigger:
		tween.tween_callback(trigger.trigger)
	tween.tween_callback(func (): GlobalReferences.player_character.release_input_lock(self))
	show()
	
