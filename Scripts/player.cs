using Godot;
using System;

public class Movement : KinematicBody2D
{
	public int speed = 200;
	Vector2 velocity = new Vector2();
	
	public void GetInput()
	{
		velocity = new Vector2();
		
		if(Input.IsActionPressed("ui_right"))
		{
			velocity.x += 1;
		}
		if(Input.IsActionPressed("ui_left"))
		{
			velocity.x -= 1;
		}
		velocity = velocity.Normalized() * speed;
	}
	
	public override void _PhysicsProcess(float delta)
	{
		GetInput();
		velocity = MoveAndSlide(velocity);
	}
}
