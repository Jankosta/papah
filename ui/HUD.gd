extends CanvasLayer

@onready var coin_count: Label = $CoinCount

func _process(_delta: float) -> void:
	coin_count.text = "Coins: " + str(GameStats.coins)
