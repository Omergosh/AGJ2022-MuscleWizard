extends Node2D


# Declare member variables here. Examples:
var health = 5
signal smashed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(damageTaken, damageType):
	print("Damage: ", damageTaken)
	if damageType == 'Physical':
		health -= damageTaken
	if health <= 0:
		emit_signal('smashed')
		#put in sound + death 
