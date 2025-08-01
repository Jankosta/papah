extends Area3D

var target_player: CharacterBody3D = null
var velocity := Vector3.ZERO
var jump_boost := 16.0
var follow_speed := 9.0  # Horizontal speed
var vertical_speed := 8.0 
var pickup_distance := 0.75
var homing := false

@onready var animation: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("players") and not homing:
		target_player = body
		homing = true
		animation.speed_scale = 25.0

func _physics_process(delta: float) -> void:
	if homing and target_player:
		var to_target = target_player.global_position - global_position

		# Horizontal
		var flat_dir = Vector3(to_target.x, 0, to_target.z).normalized()
		velocity.x = flat_dir.x * follow_speed
		velocity.z = flat_dir.z * follow_speed
		follow_speed += 0.1

		# Vertical 
		if abs(to_target.y) > 0.1:
			velocity.y = sign(to_target.y) * vertical_speed
		elif abs(to_target.y) > 0.05:
			velocity.y = sign(to_target.y) * vertical_speed * 0.5
		else:
			velocity.y = 0.0

		# Jump boost
		velocity.y += jump_boost
		jump_boost = max(0.0, jump_boost - 1.0)

		# Move
		global_position += velocity * delta

		# Pick up
		if global_position.distance_to(target_player.global_position) < pickup_distance:
			queue_free()
