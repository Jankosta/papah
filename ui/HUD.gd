extends CanvasLayer

@onready var coin_count: Label = $CoinCount

func _process(delta: float) -> void:
	coin_count.text = "Coins: " + str(GameStats.coins)
