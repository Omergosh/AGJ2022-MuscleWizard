extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var moveSpeed = 400
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_player()

func move_player():
	var newVelocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		newVelocity.x -= moveSpeed
		$Sprite.flip_h = true
	if Input.is_action_pressed("move_right"):
		$Sprite.flip_h = false
		newVelocity.x += moveSpeed
	if Input.is_action_pressed("move_up"):
		newVelocity.y -= moveSpeed
	if Input.is_action_pressed("move_down"):
		newVelocity.y += moveSpeed
	velocity = newVelocity
	move_and_slide(velocity)
