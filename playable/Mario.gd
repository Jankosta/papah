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
	#Charge Jump Handling
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if state == "charge":
			bonus_speed = charge
			charge = 0.0
			state = "neutral"
	
	# BaseCharacter logic
	super._physics_process(delta)
	
	# Dash
	if Input.is_action_pressed("sprint") and state == "neutral" and is_on_floor():
		state = "charge"
		charge = 0
		bonus_speed = 0
		
	if Input.is_action_just_released("sprint") and state == "charge":
		state = "neutral"
		if charge < 4.0:
			charge = 0.0
		else:
			bonus_speed = charge
			charge = 0.0
		
	if state == "charge":
		if GameStats.charge_cap == false:
			charge = min(charge + 0.15, 8.0)
		else:
			charge += 0.15
	
	# Charge Color
	if state == "charge":
		Sprite.modulate = Color(1.0 - (charge - 4.0)/8.0, 1.0 - (charge- 4.0)/8.0, 1.0)
	else:
		Sprite.modulate = Color(1.0, 1.0, 1.0)  # Reset to normal
	
	Sprite.play(new_animation + new_suffix)
