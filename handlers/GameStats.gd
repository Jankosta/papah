extends Node

# Game State
var player: CharacterBody3D = null

# Coins
var coins: int = 0
var collected_coins: = {}
var red_coin_count : int = 0

func add_coins(amount: int) -> void:
	coins += amount

func remove_coins(amount: int) -> void:
	coins = max(coins - amount, 0)

# Transition
var transition_state := 0
var transition_id := -1
var active_character := "mario"

# Unlocks
var unlock_luigi := false

# Debug
var debug_active := false
var charge_cap := true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_1"):
		debug_active = !debug_active
		
	if debug_active:
		if Input.is_action_just_pressed("debug_2"):
			charge_cap = !charge_cap
	else:
		charge_cap = true
		
	if debug_active:
		if Input.is_action_just_pressed("debug_3"):
			MusicHandler.play_music("res://audio/music/Baby.ogg")
