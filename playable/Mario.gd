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
