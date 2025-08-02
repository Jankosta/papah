extends Node3D

var characters := {
	"mario": preload("res://playable/Mario.tscn"),
	"luigi": preload("res://playable/Luigi.tscn")
}

var current_character: CharacterBody3D

var swapping := false
var swap_timer := 0.0
var swap_direction := 1 
const ROT_SPEED := 420.0 
var rot_dir := 1

func _ready():
	spawn_character(GameStats.active_character)

func _process(delta):
	if swapping:
		handle_swap_animation(delta)
	elif Input.is_action_just_pressed("swap") and current_character.state == "neutral":
		if GameStats.unlock_luigi == true:
			start_swap()
		
func start_swap():
	swapping = true
	swap_timer = 0.0
	swap_direction = 1

	current_character.set_frozen(true)
	current_character.Sprite.play("jump")

	current_character.set_meta("rotation_offset", 0.0 if current_character.face_right else 180.0)
	rot_dir = -1 if current_character.face_right else 1

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

		# Determine next character based on current one
		var new_name := "luigi" if current_character.character.to_lower() == "mario" else "mario"
		GameStats.active_character = new_name
		current_character.queue_free()

		var new_scene = characters[new_name]
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

func spawn_character(spawn_name: String):
	if not characters.has(spawn_name):
		push_error("Unknown character: " + spawn_name)
		return

	# Default Position
	var pos := Vector3(0, 0.5, 0) 
	var face_right := true
	
	await get_tree().create_timer(0.01).timeout

	# Find the loading zone with matching id
	for zone in get_tree().get_nodes_in_group("loading zone"):
		if zone.id == GameStats.transition_id:
			pos = zone.global_transform.origin
			pos.y -= 1.0
			break

	if current_character:
		face_right = current_character.face_right
		current_character.queue_free()

	var scene = characters[spawn_name]
	current_character = scene.instantiate()
	add_child(current_character)
	current_character.global_transform.origin = pos
	current_character.reparent(self)

	current_character.face_right = face_right
	current_character.Sprite.rotation_degrees.y = 0.0 if face_right else 180.0
