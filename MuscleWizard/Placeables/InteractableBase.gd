extends Node2D

export(String) var dialogueKeyToPlay
var inRange = false
var alreadyInteracting = false
var playerRef = null
export(String, "OnOverlap", "OnInteract") var InteractTrigger
signal talking
signal stopped_talking
# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/DialogueBox".connect("finished", self, "afterDialogueEffect")
	DialogueChoice.connect("optionMade", self, "optionPicked")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	
	if event.is_action_pressed("interact") and inRange and not alreadyInteracting:
		if InteractTrigger == "OnInteract":
			alreadyInteracting = true
			emit_signal("talking")
			$"/root/DialogueBox".playDialogue(dialogueKeyToPlay)

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		inRange = true
		playerRef = body
		if InteractTrigger == "OnOverlap":
			emit_signal("talking")
			$"/root/DialogueBox".playDialogue(dialogueKeyToPlay)


func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		inRange = false
		playerRef = null

func afterDialogueEffect():
	alreadyInteracting = false
	emit_signal("stopped_talking")

func optionPicked(choiceMade):
	GameManager.playerChoices.append(choiceMade)
	playerRef.loadPlayerChoices()

func _on_Dummy_smashed():
	position.x = 1151
	dialogueKeyToPlay = "DummyBrawn"
	print('dialogueKeyToPlay')

func _on_Dummy_zapped():
	position.x = 1151
	dialogueKeyToPlay = "DummyMagic"
	print('dialogueKeyToPlay')




func _on_Door_bashed():
	position.x = 2678
	dialogueKeyToPlay = "DoorBrawn"
	print('dialogueKeyToPlay')

func _on_Door_unlocked():
	position.x = 2678
	dialogueKeyToPlay = "DoorMagic"
	print('dialogueKeyToPlay')



func _on_FinalDialogue_body_entered(body):
	if body.is_in_group('Player'):
		position.x = 3934
		dialogueKeyToPlay = "DoorMagic"
		#print('dialogueKeyToPlay')
		DialogueChoice.connect("optionMade", self, 'quest_started')
func quest_started(yee):
	SceneTransition.transitionTo("res://Levels/Level1Actual.tscn")
