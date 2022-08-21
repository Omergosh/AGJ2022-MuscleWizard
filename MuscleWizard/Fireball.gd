extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$FireForm.play()


#straightline travel from staff, explode on contact.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SummonTimer_timeout():
	$Fire.visible = true
	$Fireform.visible = false
