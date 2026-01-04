extends Panel

@export var default_focused: UISelectable

var focused: UISelectable


func _ready() -> void:
	hide()
	focus(get_default_focused())
	GlobalReferences.level_select_panel = self


func _physics_process(_delta: float) -> void:
	if not visible:
		return
	if Input.is_action_just_pressed("ui_cancel"):
		close()
	if not focused is UISelectable:
		return
	if Input.is_action_just_pressed("ui_up") and focused.up is UISelectable:
		focus(focused.up)
	elif Input.is_action_just_pressed("ui_down") and focused.down is UISelectable:
		focus(focused.down)
	elif Input.is_action_just_pressed("ui_left") and focused.left is UISelectable:
		focus(focused.left)
	elif Input.is_action_just_pressed("ui_right") and focused.right is UISelectable:
		focus(focused.right)
	if Input.is_action_just_pressed("ui_accept"):
		close()
		focused.select()


func open():
	focus(get_default_focused())
	show()
	GlobalReferences.player_character.claim_input_lock(self)


func close():
	hide()
	GlobalReferences.player_character.release_input_lock(self)


func get_default_focused() -> UISelectable:
	if default_focused is UISelectable:
		return default_focused
	for child in $TextureRect/SubViewport.get_children():
		if child is UISelectable:
			return child
	return null


func focus(new_focused: UISelectable):
	if new_focused == null:
		return
	if focused is UISelectable:
		focused.unfocus()
	focused = new_focused
	new_focused.focus()
