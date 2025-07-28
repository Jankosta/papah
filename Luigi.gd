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
