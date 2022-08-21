extends CanvasLayer


var Text
var Name
var Portrait
var filePath = "res://UI/Dialogue/dialogue.json"
var txtDictionary
export(bool) var debug = false
var lastUsedDialogueKey
var lastUsedDialogueIndex


signal finished

# Called when the node enters the scene tree for the first time.
func _ready():
	Text = $Popup/HBoxContainer/Text
	Name = $Popup/HBoxContainer/MarginContainer/VBoxContainer/Name
	Portrait = $Popup/HBoxContainer/MarginContainer/VBoxContainer/Portrait
	var file = File.new()
	file.open(filePath, File.READ)
	txtDictionary = file.get_as_text()
	file.close()
	var err = JSON.parse(txtDictionary)
	if err.result == null:
		print(err)
	txtDictionary = JSON.parse(txtDictionary).result


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func playDialogue(dialogueKey):
	showDialogue(dialogueKey, 0)

# txtDictionary is a json struct with the following data:
# text - What the speaker is saying. Try not to say too much or it will clip off.
# name - The name to display for who is speaking
# portrait - The sprite to use for the portrait, as a str path
func showDialogue(dialogueKey, index):
	if !(dialogueKey in txtDictionary):
		print("Invalid dialogue key given, returning early! Bad key: ", dialogueKey)
		return
	var dialogueData = txtDictionary[dialogueKey][index]
	if "choicesEffects" in dialogueData:
		DialogueChoice.setup(dialogueData["choicesEffects"], dialogueData["choicesText"])
	else:
		Text.text = dialogueData["text"]
		Name.text = dialogueData["name"]
		Portrait.texture = load(dialogueData["portrait"])
		$Popup.popup()
	
	lastUsedDialogueKey = dialogueKey
	lastUsedDialogueIndex = index


func _on_Popup_popup_hide():
	tryNextDialogue()

func tryNextDialogue():
	var dialogueData = txtDictionary[lastUsedDialogueKey]
	if len(dialogueData)-1 > lastUsedDialogueIndex:
		showDialogue(lastUsedDialogueKey, lastUsedDialogueIndex+1)
	else:
		emit_signal("finished")
