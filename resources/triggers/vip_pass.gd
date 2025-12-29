extends Resource

static func trigger():
	GlobalReferences.player_character.add_inventory_item("vip_pass")
	Wwise.set_state("Ambience", "Rain_Storm")
	GlobalReferences.ambient_environment.set_preset(DirectionalLight.presets.MOON)
