class_name CollectItem
extends Trigger

@export var name := "Item"

func trigger():
	GlobalReferences.player_character.add_inventory_item(name)
