extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var moveSpeed = 400


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x -= moveSpeed
	if Input.is_action_pressed("move_right"):
		velocity.x += moveSpeed
	if Input.is_action_pressed("move_up"):
		velocity.y -= moveSpeed
	if Input.is_action_pressed("move_down"):
		velocity.y += moveSpeed
	move_and_slide(velocity)
