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
var wallDirection = 1
var isCollidingJumpPad = false
onready var defaultHitbox = $defaultHitbox
onready var crouchHitbox = $crouchHitbox
onready var walkHitbox = $walkHitbox

func _physics_process(delta: float) -> void:
	#print(state)
	var space_state = get_world_2d().direct_space_state
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	if state == "walSlide":
		direction.x *= -1
	#direction.y *= 2
	if isCollidingJumpPad:
		_velocity.y -= 3000
		print(_velocity)
		print(isCollidingJumpPad)
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	#_velocity.y *= 0.9
	if Input.get_action_strength("jump") != 0 and state != "wallSlide":
		state = "jump"
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
	elif state != "crouch" and state != "crouchWalking" and state != "sprint" and canUncrouch and state != "jump":
		state = "idle"
	elif state == "crouchWalk":
		state = "crouch"
	if Input.is_action_pressed("crouch") or (!canUncrouch and state == "crouch"):
		if state != "crouchWalk":
			state = "crouch"
	elif canUncrouch and state != "walk" and state != "sprint" and state != "jump":
		state = "idle"
	if wallDirection != 0 and (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
		state = "wallSlide"
	elif state == "wallSlide" && wallDirection == 0:
		state = "idle"
	if Input.is_action_just_pressed("reset"):
		reset()
	if state == "jump" and is_on_floor():
		state = "default"
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
	elif state == "jump":
		$defaultHitbox.disabled = false
		$crouchHitbox.disabled = true
		$AnimatedSprite.animation = "jumpAnimation"
		Multiplier = 1
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(
		_velocity , snap, FLOOR_NORMAL, true
	)
	updateWallDirection()
	isCollidingJumpPad = false
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		-Input.get_action_strength("jump") if (is_on_floor() or state == "wallSlide") and Input.is_action_just_pressed("jump") else 0.0
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
	#print(direction.y)
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y = 0.0
	return velocity

func reset():
	get_tree().reload_current_scene()

func checkWall(raycast):
	if raycast.is_colliding() and !is_on_floor():
		return true
	else:
		return false

func updateWallDirection():
	var isNearWallLeft = checkWall($leftCollision)
	var isNearWallRight = checkWall($rightCollision)
	if isNearWallLeft && isNearWallRight:
		wallDirection = 0
	else:
		wallDirection = -int(isNearWallLeft) + int(isNearWallRight)


func _on_JumpPad_body_entered(body):
	if body.name == "Player":
		isCollidingJumpPad = true
