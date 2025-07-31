extends Node3D

var mario := preload("res://playable/Mario.tscn")
var luigi := preload("res://playable/Luigi.tscn")
var current_character: CharacterBody3D

var swapping := false
var swap_timer := 0.0
var swap_direction := 1 
const ROT_SPEED := 420.0 
var rot_dir := 1

func _ready():
	spawn_character(mario)

func _process(delta):
	if swapping:
		handle_swap_animation(delta)
	elif Input.is_action_just_pressed("swap") and current_character.state == "neutral":
		start_swap()
		
func start_swap():
	swapping = true
	swap_timer = 0.0
	swap_direction = 1

	current_character.set_frozen(true)
	current_character.Sprite.play("jump")

	# Save direction
	current_character.set_meta("rotation_offset", 0.0 if current_character.face_right else 180.0)
	if current_character.face_right:
		rot_dir = -1
	else:
		rot_dir = 1
	
func handle_swap_animation(delta: float) -> void:
	swap_timer += delta * ROT_SPEED * swap_direction

	var offset = current_character.get_meta("rotation_offset")
	current_character.Sprite.rotation_degrees.y = offset + swap_timer * rot_dir

	if swap_direction == 1 and swap_timer >= 90.0:
		swap_timer = 90.0
		swap_direction = -1

		var pos = current_character.global_transform.origin
		var face_right = current_character.face_right
		offset = current_character.get_meta("rotation_offset")
		
		var temp_velocity = current_character.velocity
		var temp_bonus_speed = current_character.bonus_speed

		var new_scene = luigi if current_character.character == "Mario" else mario
		current_character.queue_free()

		current_character = new_scene.instantiate()
		$"../SpawnArea".add_child(current_character)
		current_character.global_transform.origin = pos
		current_character.reparent(self)
		
		current_character.velocity = temp_velocity
		current_character.bonus_speed = temp_bonus_speed

		current_character.face_right = face_right
		current_character.set_meta("rotation_offset", offset)
		current_character.Sprite.rotation_degrees.y = offset + 90.0
		current_character.set_frozen(true)
		current_character.Sprite.play("jump")

	elif swap_direction == -1 and swap_timer <= 0.0:
		swap_timer = 0.0
		offset = current_character.get_meta("rotation_offset")
		current_character.Sprite.rotation_degrees.y = offset
		current_character.set_frozen(false)
		swapping = false

func spawn_character(scene: PackedScene):
	var pos := Vector3(0, 0.5, 0) # Default Spawn
	var face_right := true # Fallback

	if current_character:
		pos = current_character.global_transform.origin
		face_right = current_character.face_right
		current_character.queue_free()

	current_character = scene.instantiate()
	$"../SpawnArea".add_child(current_character)
	current_character.global_transform.origin = pos
	current_character.reparent(self)

	current_character.face_right = face_right
	current_character.Sprite.rotation_degrees.y = 0.0 if face_right else 180.0
