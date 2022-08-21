extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Popup.popup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Dialogue data is a json struct with the following data:
# text - What the speaker is saying. Try not to say too much or it will clip off.
# name - The name to display for who is speaking
# portrait - The sprite to use for the portrait
func showDialogue(dialogueData):
	$Label.text = dialogeData["text"]
	
