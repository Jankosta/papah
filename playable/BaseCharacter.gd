extends CharacterBody3D
class_name BaseCharacter

@onready var Debug := $CanvasLayer/Debug
@onready var Sprite: AnimatedSprite3D = $Sprite
@onready var JumpSound := $JumpSound

# State Declarations
var state := "neutral"
var character := "base"
var frozen := false

# Physics Declarations
var ground_speed := 8.0
var air_speed := 8.0
var move_speed := 0.0
var jump_velocity := 12.5
var gravity := -40.0
var max_fall_speed := -40.0
var traction := 10.0

# Ability Stuff
var bonus_speed := 0.0
var bonus_jump := 0.0
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
	add_to_group("players")
	Sprite.play("idle")

func _physics_process(delta: float) -> void:
	if frozen:
		return
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y < max_fall_speed:
			velocity.y = max_fall_speed

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor() and state != "control":
		velocity.y = jump_velocity + bonus_jump + (bonus_speed * 0.3)
		JumpSound.play()
	if Input.is_action_just_released("jump") and velocity.y > 0:
		velocity.y *= 0.5
		
	# Reset Bonus Jump
	if is_on_floor():
		bonus_jump = 0.0

	# Movement
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		bonus_speed = max(bonus_speed - 0.05, 0.0)
		move_speed = ground_speed
	else:
		move_speed = air_speed

	if state == "neutral":
		if direction:
			velocity.x = direction.x * (move_speed * (1 + bonus_speed / 8.0))
			velocity.z = direction.z * (move_speed * (1 + bonus_speed / 8.0))
		else:
			velocity.x = move_toward(velocity.x, 0, (move_speed * (1 + bonus_speed / 8.0)) * delta * traction)
			velocity.z = move_toward(velocity.z, 0, (move_speed * (1 + bonus_speed / 8.0)) * delta * traction)
	elif state == "charge":
		velocity.x = move_toward(velocity.x, 0, move_speed * delta * traction * 2.0)
		velocity.z = move_toward(velocity.z, 0, move_speed * delta * traction * 2.0)
	elif state == "control":
		velocity.x = move_toward(velocity.x, 0, move_speed * delta)
		velocity.z = move_toward(velocity.z, 0, move_speed * delta)
		
	if velocity == Vector3.ZERO:
		bonus_speed -= 0.2
	if bonus_speed < 4.0:
		bonus_speed = 0.0
	
	move_and_slide()
	
	# Flip
	var target_rotation := Sprite.rotation_degrees.y

	if is_on_floor() and (bonus_speed == 0.0) and state != "control":
		if input_dir.x > 0.0 and not face_right:
			face_right = true
			is_flipping = true
		elif input_dir.x < 0.0 and face_right:
			face_right = false
			is_flipping = true
	
	target_rotation = 0.0 if face_right else 180.0
	
	# Spin
	if bonus_speed > 0.0 and state == "neutral":
		Sprite.rotation_degrees.y += ((bonus_speed) * 100) * delta
		Sprite.rotation_degrees.y = fmod(Sprite.rotation_degrees.y, 360.0)
		
	if bonus_speed < 4.0 and not is_flipping:
		Sprite.rotation_degrees.y = move_toward(Sprite.rotation_degrees.y, target_rotation, FLIP_SPEED)

	# Execute flip
	if is_flipping:
		Sprite.rotation_degrees.y = move_toward(Sprite.rotation_degrees.y, target_rotation, FLIP_SPEED)
		if abs(Sprite.rotation_degrees.y - target_rotation) <= 0.5:
			Sprite.rotation_degrees.y = target_rotation
			is_flipping = false
			
	# Face Up Check
	if is_on_floor() and state != "control":
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
				
	if state == "control":
		if is_on_floor():
			if velocity != Vector3.ZERO:
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
		
	if bonus_speed > 0.0 and state == "neutral":
		new_animation = "spin"
		new_suffix = ""
		
	# GUI
	
	
	# Debug
	Debug.text = "Velocity:\n" + "X: %.2f\nY: %.2f\nZ: %.2f" % [velocity.x, velocity.y, velocity.z]
	Debug.text += "\nBonus Speed: %.2f" % bonus_speed
	Debug.text += "\nCharacter: %s" % character
	Debug.text += "\nState: %s" % state
	Debug.text += "\nCharge (Shift): %.2f" % charge
	Debug.text += "\nCharge Cap: %s" % charge_cap
	
	if Input.is_action_just_pressed("debug_1"):
		charge_cap = !charge_cap
		
func set_frozen(value: bool) -> void:
	frozen = value
	set_physics_process(!value)
