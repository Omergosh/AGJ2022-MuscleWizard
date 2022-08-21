extends CanvasLayer


signal optionA
signal optionB

# Called when the node enters the scene tree for the first time.
func _ready():
	#setup("Fight", "Die")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setup(firstText, secondText):
	$PopupMenu/MarginContainer/HBoxContainer/OptionA.text = firstText
	$PopupMenu/MarginContainer/HBoxContainer/OptionB.text = secondText
	$PopupMenu.popup_centered()


func _on_OptionA_pressed():
	emit_signal("optionA")


func _on_OptionB_pressed():
	emit_signal("optionB")
