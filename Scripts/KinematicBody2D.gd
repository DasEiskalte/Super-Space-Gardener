extends KinematicBody2D

export (int) var speed = 200
export (int) var speedSprint = 400
export (int) var gravity = 600
export (int) var jump = 1100

export (int) var counter = 0

var velocity = Vector2()
var up = Vector2(0, -1)

func get_input():

	velocity = Vector2()


	if Input.is_action_pressed('ui_right'):
		velocity.x += 1


		get_node( "AnimatedSprite" ).set_flip_h( true )
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1



		get_node( "AnimatedSprite" ).set_flip_h( false )
	if Input.is_action_pressed('sprint'):
		velocity = velocity.normalized() * speedSprint
	else:
		velocity = velocity.normalized() * speed

		if !Input.is_action_pressed("ui_left") and !Input.is_action_pressed(" ui_right"):
			$AnimatedSprite.animation = "default"


	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		$AnimatedSprite.animation = "walk"
	elif Input.is_action_pressed("crouch"):
		$defaultHitbox.disabled = true
		$crouchHitbox.disabled = false
		$AnimatedSprite.animation = "crouch"


	else:
		$defaultHitbox.disabled = false
		$crouchHitbox.disabled = true
		$AnimatedSprite.animation = "default"





func _physics_process(_delta):
	get_input()

	if  is_on_floor() and Input.is_action_just_pressed("jump"):
		counter = 100

	if !is_on_floor():
		velocity.y += gravity

	if counter > 20:
		velocity.y -= jump
		counter -= 1
		jump -= 15

	if counter == 20:
		counter = 0
		jump = 1100

	if is_on_ceiling():
		counter = 20



	velocity = move_and_slide(velocity, up)
