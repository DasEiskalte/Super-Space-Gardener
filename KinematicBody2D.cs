using Godot;
using System;

public class Player : KinematicBody2D
{
	public int speed = 300
		;
	private Vector2 direction = new Vector2();
	
	public void GetInput()
	{
		direction = new Vector2();
		
		if(Input.IsActionPressed("right"))
		{
			direction.x += 1;
		}
		if(Input.IsActionPressed("left"))
		{
			direction.x -= 1;
		}
	}
	
	public override void _PhysicsProcess(float _delta)
	{
		GetInput();

		MoveAndSlide(direction.Normalized() * speed);
	}
}