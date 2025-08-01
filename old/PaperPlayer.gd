extends CharacterBody3D

@onready var Debug := $CanvasLayer/Debug
@onready var Sprite: AnimatedSprite3D = $Sprite
@onready var JumpSound := $JumpSound

# State Declarations
var state := "neutral"

# Physics Declarations
const SPEED := 8.0
const JUMP_VELOCITY := 12.5
const CUSTOM_GRAVITY := -40.0
const MAX_FALL_SPEED := -40.0

# Dash Stuff
var charge := 0.0

# Animation Declarations
const FLIP_SPEED := 15.0
var face_right := true
var is_flipping := false
var face_up := false
var new_animation := "idle"
var new_suffix := ""

# Debug
var charge_cap = true

func _ready() -> void:
	Sprite.play("idle")

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += CUSTOM_GRAVITY * delta
		if velocity.y < MAX_FALL_SPEED:
			velocity.y = MAX_FALL_SPEED

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY + (charge * 0.5)
		JumpSound.play()
		if state == "charge":
			state = "neutral"
	if Input.is_action_just_released("jump") and velocity.y > 0:
		velocity.y *= 0.5

	# Movement
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if state == "neutral":
		if is_on_floor():
			charge = max(charge - 0.05, 0.0)
		if direction:
			velocity.x = direction.x * (SPEED + charge)
			velocity.z = direction.z * (SPEED + charge)
		else:
			velocity.x = move_toward(velocity.x, 0, (SPEED + charge) * delta * 10)
			velocity.z = move_toward(velocity.z, 0, (SPEED + charge) * delta * 10)

		move_and_slide()
		
		if velocity.x == 0 and velocity.z == 0:
			charge = 0
		if charge < 4.0:
			charge = 0
		
	# Dash
	if Input.is_action_pressed("sprint") and state == "neutral" and is_on_floor():
		state = "charge"
		charge = 0
		
	if Input.is_action_just_released("sprint") and state == "charge":
		state = "neutral"
		if charge < 4.0:
			charge = 0.0
		
	if state == "charge":
		if charge_cap == true:
			charge = min(charge + 0.15, 8.0)
		else:
			charge += 0.15
	
	# Flip
	var target_rotation := Sprite.rotation_degrees.y

	if is_on_floor() and (charge == 0.0 or state == "charge"):
		if input_dir.x > 0.0 and not face_right:
			face_right = true
			is_flipping = true
		elif input_dir.x < 0.0 and face_right:
			face_right = false
			is_flipping = true
		
	# Determine the target rotation
	target_rotation = 0.0 if face_right else 180.0
	
	# Spin
	if charge > 0.0 and state == "neutral":
		Sprite.rotation_degrees.y += ((charge) * 100) * delta
		Sprite.rotation_degrees.y = fmod(Sprite.rotation_degrees.y, 360.0)
		
	if charge < 4.0 and not is_flipping:
		Sprite.rotation_degrees.y = move_toward(Sprite.rotation_degrees.y, target_rotation, FLIP_SPEED)

	# Execute flip
	if is_flipping:
		Sprite.rotation_degrees.y = move_toward(Sprite.rotation_degrees.y, target_rotation, FLIP_SPEED)
		if abs(Sprite.rotation_degrees.y - target_rotation) <= 0.5:
			Sprite.rotation_degrees.y = target_rotation
			is_flipping = false
			
	# Face Up Check
	if is_on_floor():
		if abs(input_dir.x) > abs(input_dir.y):
			face_up = false
		else:
			if input_dir.y < 0.0:
				face_up = true
			elif input_dir.y > 0.0:
				face_up = false
		
	# Sprites
	if state == "neutral":
		if is_on_floor():
			if input_dir != Vector2.ZERO:
				new_animation = "run"
			else:
				new_animation = "idle"
		else:
			if velocity.y >= -2.0:
				new_animation = "jump"
			else:
				new_animation = "fall"
				
	if state == "charge":
		new_animation = "charge"
			
	if face_up:
		new_suffix = "Back"
	else:
		new_suffix = ""
		
	if charge > 0.0 and state == "neutral":
		new_animation = "spin"
		new_suffix = ""
		
	Sprite.play(new_animation + new_suffix)
	
	# Color
	if state == "charge":
		Sprite.modulate = Color(1.0 - (charge - 4.0)/8.0, 1.0 - (charge- 4.0)/8.0, 1.0)
	elif state == "neutral" and charge > 0.0:
		Sprite.modulate = Color(1.0, 1.0, 1.0)  # Reset to normal
			
	# Debug
	Debug.text = "Velocity:\n" + "X: %.2f\nY: %.2f\nZ: %.2f" % [velocity.x, velocity.y, velocity.z]
	Debug.text += "\nState: %s" % state
	Debug.text += "\nCharge (Shift): %.2f" % charge
	Debug.text += "\nCharge Cap: %s" % charge_cap
	
	if Input.is_action_just_pressed("debug_1"):
		charge_cap = !charge_cap
