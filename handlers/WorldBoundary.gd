extends Area3D

func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		# Find active checkpoint
		for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
			if checkpoint.active:
				body.global_transform.origin = checkpoint.global_transform.origin - Vector3(0, 1.5, 0)
				break
	else:
		# Fallback
		body.global_transform.origin = Vector3(0, 0.5, 0)

	body.velocity = Vector3.ZERO
	body.bonus_speed = 0.0
