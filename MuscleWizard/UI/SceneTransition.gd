extends CanvasLayer

var levelToGoTo

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func transitionTo(strPath):
	levelToGoTo = strPath
	$AnimationPlayer.play("FadeToBlack")

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"FadeToBlack":
			var error = get_tree().change_scene(levelToGoTo)
			if error:
				print("Level transition failed???", error)
			$AnimationPlayer.play("FadeFromBlack")
		"FadeFromBlack":
			pass
