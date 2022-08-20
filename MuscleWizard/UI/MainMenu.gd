extends Control

# Manager for main menu buttons


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
	SceneTransition.transitionTo("res://Levels/BasicLevel.tscn")


func _on_Credits_pressed():
	$CreditsContainer.show()
	$MainButtons.hide()


func _on_Exit_pressed():
	get_tree().quit()


func _on_Back_pressed():
	$MainButtons.show()
	$CreditsContainer.hide()