extends Control


# Declare member variables here. Examples:
# var a = 2
var BurningSoul = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if GameManager.alive == true:
		for choice in GameManager.playerChoices:
			if choice == "WentToGym":
				$VBoxContainer/BuffEnd.show()
				$VBoxContainer/NormalEnd.hide()
				$VBoxContainer/DeathEnd.hide()
			if choice == "LearnPyro":
				$VBoxContainer/DeniedKnowledge.hide()
				$VBoxContainer/ChoseKnowledge.show()
				BurningSoul = true
			if choice == "Leave":
				$VBoxContainer/DeniedKnowledge.show()
				$VBoxContainer/ChoseKnowledge.hide()
			if choice == "AcceptWard":
				$VBoxContainer/LostArt.show()
			else:
				$VBoxContainer/EmberSoul.hide()
	if GameManager.alive == false:
		for choice in GameManager.playerChoices:
			if choice == "LearnPyro":
				$VBoxContainer/EmberSoul.show()
				BurningSoul = true
		$VBoxContainer/BuffEnd.hide()
		$VBoxContainer/DeniedKnowledge.hide()
		$VBoxContainer/ChoseKnowledge.hide()
		$VBoxContainer/NormalEnd.hide()
		$VBoxContainer/LostArt.hide()
		$VBoxContainer/DeathEnd.show()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Returntomenu_pressed():
	GameManager.alive = true
	GameManager.playerChoices = []
	SceneTransition.transitionTo('res://UI/MainMenu.tscn')
