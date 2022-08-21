extends KinematicBody2D


# Declare member variables here. Examples:
var health = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(damageTaken, damageType):
	print("Boss Damage: ", damageTaken)
	health -= damageTaken
	if health <= 0:
		start_dying()

func start_dying():
	# play sound effects + animations,
	# then call finish_dying at end of animation
	$AnimationPlayer.play("Death")
	pass

# Remove enemy from level
func finish_dying():
	queue_free()

