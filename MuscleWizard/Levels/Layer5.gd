extends Node2D

var wallbreak = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LayerTrigger_body_entered(body):
	if body.is_in_group("Player"):
		if wallbreak == false:
			$HollowWall.die()
			$HollowWall2.die()
			wallbreak = true
		for child in self.get_children():
			if child.is_in_group("Enemy"):
				child.player = body
				child.aggro = true
