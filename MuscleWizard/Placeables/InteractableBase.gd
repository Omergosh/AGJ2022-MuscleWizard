extends Node2D

export(String) var dialogueKeyToPlay
var offline = false
var inRange = false
var alreadyInteracting = false
#onready var playerRef = null
onready var playerRef = get_node("Player")
export(String, "OnOverlap", "OnInteract") var InteractTrigger
signal talking
signal stopped_talking
# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = $"/root/DialogueBox".connect("finished", self, "afterDialogueEffect")
	_err = DialogueChoice.connect("optionMade", self, "optionPicked")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if offline == true:
		#$Area2D.monitoring = false
	#if offline == false:
		#$Area2D.monitoring = true
	pass

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
		#playerRef = null
		#this was breaking the game when multiple interactable bases were present before so I took it out
		#idk if it broke something else, which is why it's still here
		#playerRef used to default to body with 'Player' group
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
		position.x = 4334
		dialogueKeyToPlay = "FinalChoice"
		#print('dialogueKeyToPlay')
		var _err = DialogueChoice.connect("optionMade", self, 'choice_made')

func choice_made(_choice):
	SceneTransition.transitionTo("res://Levels/Level1Actual.tscn")
	pass




func _on_DebugTimer_timeout():
	#print(playerRef)
	pass
