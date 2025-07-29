extends BaseCharacter

func _ready():
	ground_speed = 7.0
	air_speed = 5.0
	jump_velocity = 15.0
	gravity = -30.0
	max_fall_speed = -30.0
	traction = 3.0
	character = "Luigi"
	add_to_group("players")

func _physics_process(delta: float) -> void:
	# BaseCharacter logic
	super._physics_process(delta)
	
	if velocity.y <= 7.5 and !is_on_floor() and Input.is_action_pressed("jump"):
		new_animation = "run"
		gravity = -25.0
		max_fall_speed = -15.0
	else:
		gravity = -30.0
		max_fall_speed = -30.0

	# Test
	if Input.is_action_just_pressed("debug_3"):
		print("Luigi uses his special move!")
		
	Sprite.play(new_animation + new_suffix)
