extends Node

var coins: int = 0

func add_coins(amount: int) -> void:
	coins += amount

func remove_coins(amount: int) -> void:
	coins = max(coins - amount, 0)
