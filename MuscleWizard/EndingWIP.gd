extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if GameManager.alive == true:
		for choice in GameManager.playerChoices:
			if choice == "WentToGym":
				$VBoxContainer/BuffEnd.show()
				$VBoxContainer/NormalEnd.hide()
				$VBoxContainer/DeathEnd.hide()
			else:
				$VBoxContainer/BuffEnd.hide()
				$VBoxContainer/NormalEnd.show()
				$VBoxContainer/DeathEnd.hide()
	if GameManager.alive == false:
		$VBoxContainer/BuffEnd.hide()
		$VBoxContainer/NormalEnd.hide()
		$VBoxContainer/DeathEnd.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Returntomenu_pressed():
	SceneTransition.transitionTo('res://UI/MainMenu.tscn')
