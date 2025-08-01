extends Node3D

@export var bgm: String = ""

func _ready():
	if bgm != "":
		MusicHandler.play_music(bgm)
