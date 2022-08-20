extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var moveSpeed = 200
var health = 10
var damage = 5
var dead = false
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

func take_damage(damageTaken):
	print("Damage: ", damageTaken)
	health -= damageTaken
	if health <= 0:
		start_dying()

func start_dying():
	# play sound effects + animations,
	# then call finish_dying at end of animation
	finish_dying()

# Remove enemy from level
func finish_dying():
	queue_free()

#Shambler sight radius stuff
func _on_Sight_body_entered(body):
	aggro = true


func _on_Sight_body_exited(body):
	aggro = false
