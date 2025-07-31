extends Area3D

@export var destination_path: String
@export var direction: String

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		var packed = load(destination_path)
		walk_off(body, direction)
		TransitionFader.transition(func(): get_tree().change_scene_to_packed(packed))

func walk_off(body: Node3D, direction):
	body.state = "control"
	body.bonus_speed = 0.0
	body.velocity = Vector3.ZERO
	match direction:
		"left":
			body.velocity.x = -body.move_speed
			body.face_right = false
			body.face_up = false
		"right":
			body.velocity.x = body.move_speed
			body.face_right = true
			body.face_up = false
		"up":
			body.velocity.z = -body.move_speed
			body.face_up = true
		"down":
			body.velocity.z = body.move_speed
			body.face_up = false
		_:
			push_error("Unbound LoadingZone direction: " + str(direction))
