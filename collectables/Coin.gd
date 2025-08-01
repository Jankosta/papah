@tool
extends Area3D

@export_enum("yellow", "red", "blue")
var type: String = "yellow" : set = set_type

@export var coin_id: int = -1

@onready var sprite := $AnimatedSprite3D

var coin_sound := preload("res://audio/sounds/Coin.ogg")
var red_sound := preload("res://audio/sounds/RedCoin.ogg")

func _ready() -> void:
	update_visuals()
	
	if Engine.is_editor_hint():
		return
	
	if GameStats.collected_coins.has(coin_id):
		queue_free()

func _on_body_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("players"):
		$AnimatedSprite3D.visible = false
		match type:
			"yellow":
				play_sound(coin_sound)
				GameStats.add_coins(1)
			"blue":
				for i in 5:            
					play_sound(coin_sound)
					GameStats.add_coins(1)
					if i < 4:
						await get_tree().create_timer(0.1).timeout
			"red":
				play_sound(red_sound)
				GameStats.add_coins(1)
				await get_tree().create_timer(0.1).timeout
				GameStats.add_coins(1)
			_:
				pass
		GameStats.collected_coins[coin_id] = true
		queue_free()

func play_sound(sound):
	var player := AudioStreamPlayer3D.new()
	player.stream = sound
	player.bus = "Sfx"
	player.transform.origin = global_transform.origin
	get_tree().current_scene.add_child(player)
	player.play()
	player.finished.connect(func(): player.queue_free())
	
func update_visuals():
	if not sprite:
		return
	sprite.animation = type
	
func set_type(value: String) -> void:
	type = value
	update_visuals()
