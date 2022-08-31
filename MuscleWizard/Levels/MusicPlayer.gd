extends Node2D


var music_on = true
var quiet_melody = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if music_on == true:
		$TrueQuietude.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("music"):
		toggle_music()

func play_track():
	if music_on == true:
		if quiet_melody == false:
			$TrueQuietude.play()
		if quiet_melody == true:
			$Quietude.play()
			
func toggle_music():
	if music_on == true:
		if $Quietude.playing == true:
			$Quietude.stop()
		if $TrueQuietude.playing == true:
			$TrueQuietude.stop()
	if music_on == false:
		play_track()


func _on_QuietSwitchBoss_body_entered(body):
	if body.is_in_group("Player"):
		if quiet_melody == false:
			quiet_melody = true
		elif quiet_melody == true:
			quiet_melody = false
		print('melody')
		print(quiet_melody)

func _on_QuietSwitchBoss_body_exited(body):
	#if body.is_in_group("Player"):
		#quiet_melody = false
	pass

func _on_Quietude_finished():
	play_track()


func _on_TrueQuietude_finished():
	play_track()
