extends CharacterBody3D

@onready var Sprite: AnimatedSprite3D = $Sprite
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

const FLIP_SPEED := 12.0
var face_right := true
var is_flipping := false
var new_animation := "idle"
var new_suffix := ""

func _ready() -> void:
	add_to_group("npcs")

func _physics_process(delta: float) -> void:
	# Flip
	var target_rotation := Sprite.rotation_degrees.y
	
	if GameStats.player:
		if GameStats.player.global_transform.origin.x < global_transform.origin.x and not face_right:
			face_right = true
			is_flipping = true
		elif GameStats.player.global_transform.origin.x > global_transform.origin.x and face_right:
			face_right = false
			is_flipping = true
	
	target_rotation = 0.0 if face_right else 180.0
	
	# Execute flip
	if is_flipping:
		Sprite.rotation_degrees.y = move_toward(Sprite.rotation_degrees.y, target_rotation, FLIP_SPEED)
		if abs(Sprite.rotation_degrees.y - target_rotation) <= 0.5:
			Sprite.rotation_degrees.y = target_rotation
			is_flipping = false


func _on_bounce_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		var npc_position = global_transform.origin
		var player_position = body.global_transform.origin

		var direction = (player_position - npc_position)
		direction.y = 0
		direction = direction.normalized()

		# Set bounce velocity
		var bounce_strength := 10.0
		var lateral_push_strength := 15.0

		GameStats.player.velocity.y = bounce_strength
		GameStats.player.velocity.x = direction.x * lateral_push_strength
		GameStats.player.velocity.z = direction.z * lateral_push_strength
