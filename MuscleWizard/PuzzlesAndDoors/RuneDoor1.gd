extends Node2D


# Declare member variables here. Examples:
var health = 5
signal bashed
signal unlocked
var keyhole = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if keyhole == 2:
		emit_signal("unlocked")
		print('unlocked')

func take_damage(damageTaken, damageType):
	if damageType == 'Physical':
		health -= damageTaken
	if health <= 0:
		emit_signal('bashed')
		#put in sound + death 


func _on_Sconce_keys():
	keyhole += 1


func _on_Sconce_lock():
	keyhole -= 1


func _on_Sconce2_keys():
	keyhole += 1


func _on_Sconce2_lock():
	keyhole -= 1
