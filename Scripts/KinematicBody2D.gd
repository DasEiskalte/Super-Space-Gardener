extends Actor


export (float) var speedMultiplier = 1.25
export (float) var crouchMultiplier = 0.75
var Multiplier = 1
export (int) var jump = 1100
var isCrouched = false
var canUncrouch = false
var isWalking = false
var isCrouchWalking = false
var isSprinting = false
var state = "idle"
onready var defaultHitbox = $defaultHitbox
onready var crouchHitbox = $crouchHitbox
onready var walkHitbox = $walkHitbox

func _physics_process(delta: float) -> void:
	print(state)
	var space_state = get_world_2d().direct_space_state
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	if $raycastCrouch.is_colliding() and (state == "crouch" or state == "crouchWalk"):
			canUncrouch = false
	else:
			canUncrouch = true
	if Input.is_action_pressed("sprint") and state == "walk":
		state = "sprint"
	if !Input.is_action_pressed("sprint") and state == "sprint":
		state = "walk"
	if Input.is_action_pressed("ui_left"):
		if state != "crouch" and state != "crouchWalk" and state != "sprint":
			state = "walk"
		elif state != "sprint":
			state = "crouchWalk"
		get_node( "AnimatedSprite" ).set_flip_h( false )
	elif Input.is_action_pressed("ui_right"):
		if state != "crouch" and state != "crouchWalk" and state != "sprint":
			state = "walk"
		elif state != "sprint":
			state = "crouchWalk"
		get_node( "AnimatedSprite" ).set_flip_h( true )
	elif state != "crouch" and state != "crouchWalking" and state != "sprint" and canUncrouch:
		state = "idle"
	elif state == "crouchWalk":
		state = "crouch"
	if Input.is_action_pressed("crouch") or (!canUncrouch and state == "crouch"):
		if state != "crouchWalk":
			state = "crouch"
	elif canUncrouch and state != "walk" and state != "sprint":
		state = "idle"
	if isSprinting:
		Multiplier = speedMultiplier
	elif isCrouched or isCrouchWalking:
		Multiplier = crouchMultiplier
	else:
		Multiplier = 1
	if Input.is_action_just_pressed("reset"):
		reset()
	if state == "crouch":
		$defaultHitbox.disabled = true
		$crouchHitbox.disabled = false
		$AnimatedSprite.animation = "crouch"
		Multiplier = crouchMultiplier
	elif state == "idle":
		$defaultHitbox.disabled = false
		$crouchHitbox.disabled = true
		$AnimatedSprite.animation = "default"
		Multiplier = 1
	elif state == "walk":
		$defaultHitbox.disabled = false
		$crouchHitbox.disabled = true
		$AnimatedSprite.animation = "walk"
		Multiplier = 1
	elif state == "crouchWalk":
		$defaultHitbox.disabled = true
		$crouchHitbox.disabled = false
		$AnimatedSprite.animation = "crouchWalk"
		Multiplier = crouchMultiplier
	elif state == "sprint":
		$defaultHitbox.disabled = false
		$crouchHitbox.disabled = true
		$AnimatedSprite.animation = "walk"
		Multiplier = speedMultiplier
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(
		_velocity, snap, FLOOR_NORMAL, true
	)


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	speed.x *= Multiplier
	var velocity: = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y = 0.0
	return velocity

func reset():
	get_tree().reload_current_scene()
