extends BaseCharacter

func _ready():
	ground_speed = 8.0
	air_speed = 8.0
	jump_velocity = 12.5
	gravity = -40.0
	max_fall_speed = -40.0
	traction = 10.0
	character = "Mario"
	add_to_group("players")

func _physics_process(delta: float) -> void:
	# BaseCharacter logic
	super._physics_process(delta)

	# Test
	if Input.is_action_just_pressed("debug_3"):
		print("Mario uses his special move!")
		
	Sprite.play(new_animation + new_suffix)
