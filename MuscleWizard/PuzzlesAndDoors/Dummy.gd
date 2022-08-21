# Declare member variables here. Examples:
extends Node2D

var health = 5
signal smashed 
signal zapped
signal died
var cause_of_death = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(damageTaken, damageType):
	if damageType in cause_of_death:
		cause_of_death[damageType] += damageTaken
	if damageType == 'Physical':
		emit_signal("smashed")
	elif damageType == 'Magic':
		emit_signal('zapped')
	emit_signal('died')
	queue_free()
