extends Node


static func trigger():
	Wwise.set_state("Ambience", "Outdoor_Sunny")
	GlobalReferences.ambient_environment.set_preset(DirectionalLight.presets.SUN)
