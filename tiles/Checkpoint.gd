extends Area3D

var active := false

func _ready() -> void:
	add_to_group("checkpoints")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		activate()

func activate():
	active = true
	# Deactivate all other checkpoints
	for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
		if checkpoint != self:
			checkpoint.deactivate()

func deactivate():
	active = false
