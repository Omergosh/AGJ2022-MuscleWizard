extends Node2D


var ember = false
var player_seen = false
var used = false
signal delete_interact
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Pyrosense_body_entered(body):
	if body.is_in_group("Player"):
		if body.pyromancy == true:
			if player_seen == false:
				ember = true
				player_seen = true
			$PyroNormal.queue_free()
			$Embers.emitting = true
			$Trigger/Burning.play()
		if body.pyromancy == false:
			ember = false
			$PyroInteract.queue_free()
			$Trigger.queue_free()



func _on_Trigger_body_entered(body):
	if body.is_in_group("Player"):
		if ember == true:
			$Trigger/Burning.stop()
			$Trigger/Snap.play()
			$PyroInteract.queue_free()
			$Embers.emitting = false
			used = true
			body.health += 20
			ember = false
			emit_signal("delete_interact")
