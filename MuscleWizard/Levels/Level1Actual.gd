extends Node2D


# Declare member variables here. Examples:
# var a = 2
onready var pc = get_node("Player")
var set_book = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if set_book == false:
		if pc.smart == true:
			$MagicBook/InteractableBase.queue_free()
		if pc.jacked == true:
			$MagicBook/InteractableBase2.queue_free()
		else:
			$MagicBook/InteractableBase.queue_free()
		set_book = true


func _on_InteractZone_body_entered(body):
	if body.is_in_group('Player'):
		body.use_e = true


func _on_InteractZone_body_exited(body):
	if body.is_in_group('Player'):
		body.use_e = false
