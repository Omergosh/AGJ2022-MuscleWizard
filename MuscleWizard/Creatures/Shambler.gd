extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var moveSpeed = 200
var health = 10
var damage = 5
var onfire = false
var alive = true
var aggro = false
var direction = 0
onready var player = get_node("../Player")
var velocity = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alive == true and aggro == true:
		direction = (player.position - position).normalized()
		move_and_slide(direction * moveSpeed)
	else:
		pass



#Shambler sight radius stuff
func _on_Sight_body_entered(body):
	aggro = true


func _on_Sight_body_exited(body):
	aggro = false
