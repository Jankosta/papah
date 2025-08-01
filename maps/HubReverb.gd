extends Node3D

func _ready() -> void:
	var sfx_bus_index = AudioServer.get_bus_index("Sfx")
	AudioServer.set_bus_effect_enabled(sfx_bus_index, 0, true)  

func _exit_tree() -> void:
	var sfx_bus_index = AudioServer.get_bus_index("Sfx")
	AudioServer.set_bus_effect_enabled(sfx_bus_index, 0, false)
