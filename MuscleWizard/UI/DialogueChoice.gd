extends CanvasLayer


signal optionMade
var options = ["placeholderA", "placeholderB"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# NewOptions is an array of length 2 of strings
func setup(Effects, Text):
	options = Effects
	$PopupMenu/MarginContainer/HBoxContainer/OptionA.text = Text[0]
	$PopupMenu/MarginContainer/HBoxContainer/OptionB.text = Text[1]
	$PopupMenu.popup_centered()


func _on_OptionA_pressed():
	emit_signal("optionMade", options[0])
	$PopupMenu.hide()


func _on_OptionB_pressed():
	emit_signal("optionMade", options[1])
	$PopupMenu.hide()
