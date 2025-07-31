extends Area3D

func _on_body_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("players"):
		GameStats.add_coins(2)
		queue_free()
