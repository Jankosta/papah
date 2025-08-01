extends Node

var coins: int = 0
var collected_coins: = {}

var transition_state := 0
var transition_id := -1
var active_character := "mario"

func add_coins(amount: int) -> void:
	coins += amount

func remove_coins(amount: int) -> void:
	coins = max(coins - amount, 0)
