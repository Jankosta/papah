extends BaseCharacter

func _ready():
	ground_speed = 7.0
	air_speed = 5.0
	jump_velocity = 15.0
	gravity = -30.0
	max_fall_speed = -40.0
	traction = 3.0
	character = "Luigi"
	add_to_group("players")

func _physics_process(delta: float) -> void:
	#Charge Jump Handling
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if state == "charge":
			bonus_jump = charge/2.0
			charge = 0.0
			state = "neutral"
			
	# BaseCharacter logic
	super._physics_process(delta)
	
	if Input.is_action_pressed("sprint") and state == "neutral" and is_on_floor():
		state = "charge"
		charge = 0
		bonus_jump = 0
		
	if Input.is_action_just_released("sprint") and state == "charge":
		state = "neutral"
		if charge < 4.0:
			charge = 0.0
		else:
			bonus_jump = charge/2.0
			charge = 0.0
		
	if state == "charge":
		if charge_cap == true:
			charge = min(charge + 0.15, 8.0)
		else:
			charge += 0.15
	
	# Charge Color
	if state == "charge":
		Sprite.modulate = Color(1.0 - (charge - 4.0)/8.0, 1.0, 1.0 - (charge- 4.0)/8.0)
	else:
		Sprite.modulate = Color(1.0, 1.0, 1.0)  # Reset to normal
	
	# Scuttle Jump
	if velocity.y <= 7.5 and !is_on_floor() and Input.is_action_pressed("jump"):
		new_animation = "run"
		gravity = -27.5
		max_fall_speed = -15.0
	else:
		gravity = -30.0
		max_fall_speed = -40.0

	# Test
	if Input.is_action_just_pressed("debug_3"):
		print("Luigi uses his special move!")
		
	Sprite.play(new_animation + new_suffix)
