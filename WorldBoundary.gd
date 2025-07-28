extends Area3D

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		call_deferred("reload_scene")

func reload_scene():
	get_tree().reload_current_scene()
