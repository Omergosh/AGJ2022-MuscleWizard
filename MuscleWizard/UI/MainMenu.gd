extends Control

# Manager for main menu logic
var wasBuff = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
	SceneTransition.transitionTo('res://Levels/Level0.tscn')


func _on_Credits_pressed():
	$CreditsContainer.show()
	$CreditsContainer/VBoxContainer/CreditsLbl.show()
	$MainButtons.hide()


func _on_Exit_pressed():
	get_tree().quit()


func _on_Back_pressed():
	$MainButtons.show()
	$CreditsContainer.hide()
	$CreditsContainer/VBoxContainer/Lore.hide()
	$CreditsContainer/VBoxContainer/Controls.hide()


func _on_AnimationPlayer_animation_finished(_anim_name):
	if wasBuff:
		$AnimatedSprite.play("default")
	else:
		$AnimatedSprite.play("buff")
	
	wasBuff = !wasBuff
	
	$AnimationPlayer.play("default")


func _on_ControlsLore_pressed():
	$CreditsContainer.show()
	$CreditsContainer/VBoxContainer/Controls.show()
	$CreditsContainer/VBoxContainer/CreditsLbl.hide()
	$MainButtons.hide()


func _on_LoreB_pressed():
	$CreditsContainer.show()
	$CreditsContainer/VBoxContainer/Lore.show()
	$CreditsContainer/VBoxContainer/Controls.hide()
	$CreditsContainer/VBoxContainer/CreditsLbl.hide()
	$MainButtons.hide()
