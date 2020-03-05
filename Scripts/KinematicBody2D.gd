extends Actor


export (float) var speedMultiplier = 1.25
export (float) var crouchMultiplier = 0.75
var Multiplier = 1
export (int) var jump = 1100
var isCrouched = false

onready var defaultHitbox = $defaultHitbox
onready var crouchHitbox = $crouchHitbox
onready var walkHitbox = $walkHitbox

func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	
	if Input.is_action_pressed("sprint"):
		Multiplier = speedMultiplier
	if Input.is_action_just_released("sprint"):
		Multiplier = 1
	if Input.is_action_just_released("crouch"):
		default()
		Multiplier = 1
	if Input.is_action_pressed("ui_left"):
		if !isCrouched:
			walk()
		get_node( "AnimatedSprite" ).set_flip_h( false )
	elif Input.is_action_pressed("ui_right"):
		if !isCrouched:
			walk()
		get_node( "AnimatedSprite" ).set_flip_h( true )
	else:
		default()
	if Input.is_action_pressed("crouch"):
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			crouchWalk()
		else:
			crouch()
		Multiplier = crouchMultiplier
	if Input.is_action_just_pressed("reset"):
		reset()
		
	
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
	
func crouch():
	$defaultHitbox.disabled = true
	$crouchHitbox.disabled = false
	$walkHitbox.disabled = true
	$AnimatedSprite.animation = "crouch"
	isCrouched = true
	
func default():
	$defaultHitbox.disabled = false
	$crouchHitbox.disabled = true
	$walkHitbox.disabled = true
	$AnimatedSprite.animation = "default"
	isCrouched = false

func walk():
	$defaultHitbox.disabled = true
	$crouchHitbox.disabled = true
	$walkHitbox.disabled = false
	$AnimatedSprite.animation = "walk"
	isCrouched = false
	
func crouchWalk():
	$defaultHitbox.disabled = true
	$crouchHitbox.disabled = false
	$walkHitbox.disabled = true
	$AnimatedSprite.animation = "crouchWalk"
	isCrouched = true
	
func reset():
	get_tree().reload_current_scene()
	OS.delay.msec(1000)
	
