extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _open():
	$OpenTimer.start()
	$DoorSound.play()

func _on_Dummy_smashed():
	_open()


func _on_Dummy_zapped():
	_open()


func _on_OpenTimer_timeout():
	queue_free()
