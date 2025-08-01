extends Area3D

@export var destination_path: String
@export var direction: String
@export var id: int = 0
@export var destination_id: int = -1

func _ready() -> void:
	add_to_group("loading zone")
	if destination_id == -1:
		destination_id = id

func _on_body_entered(body: Node3D) -> void:
	if GameStats.transition_state == 0:
		if body.is_in_group("players"):
			GameStats.transition_id = destination_id
			var packed = load(destination_path)
			walk_off(body, direction)
			TransitionFader.transition(func(): get_tree().change_scene_to_packed(packed))
	elif GameStats.transition_state == 1:
		if body.is_in_group("players"):
			walk_in(body, direction)
			
func _on_body_exited(body: Node3D) -> void:
	if GameStats.transition_state == -1:
		if body.is_in_group("players"):
			await get_tree().create_timer(0.3).timeout
			body.state = "neutral"
			GameStats.transition_state = 0
			GameStats.transition_id = -1

func walk_off(body: Node3D, dir):
	GameStats.transition_state = 1
	body.state = "control"
	body.bonus_speed = 0.0
	body.velocity = Vector3.ZERO
	match dir:
		"left":
			body.velocity.x = -8.0
			body.face_right = false
			body.face_up = false
		"right":
			body.velocity.x = 8.0
			body.face_right = true
			body.face_up = false
		"up":
			body.velocity.z = -8.0
			body.face_up = true
		"down":
			body.velocity.z = 8.0
			body.face_up = false
		_:
			push_error("Unbound LoadingZone direction: " + str(direction))
			
func walk_in(body: Node3D, dir):
	GameStats.transition_state = -1
	body.state = "control"
	body.bonus_speed = 0.0
	body.velocity = Vector3.ZERO
	match dir:
		"left":
			body.velocity.x = 8.0
			body.face_right = true
			body.face_up = false
		"right":
			body.velocity.x = -8.0
			body.face_right = false
			body.Sprite.rotation_degrees.y = 180.0
			body.face_up = false
		"up":
			body.velocity.z = 8.0
			body.face_up = false
		"down":
			body.velocity.z = -8.0
			body.face_up = true
		_:
			push_error("Unbound LoadingZone direction: " + str(direction))
