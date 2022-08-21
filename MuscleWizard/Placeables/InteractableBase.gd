extends Node2D

export(String) var dialogueKeyToPlay
var inRange = false
var alreadyInteracting = false
var playerRef = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/DialogueBox".connect("finished", self, "afterDialogueEffect")
	DialogueChoice.connect("optionMade", self, "optionPicked")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	
	if event.is_action_pressed("interact") and inRange and not alreadyInteracting:
		alreadyInteracting = true
		$"/root/DialogueBox".playDialogue(dialogueKeyToPlay)

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		inRange = true
		playerRef = body


func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		inRange = false
		playerRef = null

func afterDialogueEffect():
	alreadyInteracting = false

func optionPicked(choiceMade):
	GameManager.playerChoices.append(choiceMade)
	playerRef.loadPlayerChoices()