extends Node2D


# Declare member variables here. Examples:
# var a = 2
onready var player = $Player
var diary_set = false
onready var dairy = get_node('ExplorerDiary/Buff')

# Called when the node enters the scene tree for the first time.
func _ready():
	_check_pyro()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_diary():
	if player.jacked == true:
		$ExplorerDiary/Smart.queue_free()
		var dairy = get_node('ExplorerDiary/Buff')
	if player.smart == true:
		$ExplorerDiary/Buff.queue_free()
		var dairy = get_node('ExplorerDiary/Smart')

func _check_pyro():
	if $Player.pyromancy == true:
		get_node("Ghost/Tera/Help").queue_free()
	if $Player.pyromancy == false:
		get_node("Ghost/Tera/Shun").queue_free()

func _on_ApproachBody_body_entered(body):
	if body.is_in_group('Player'):
		if diary_set == false:
			_set_diary()
			diary_set = true
		#dairy.offline = false
		#print('enter')

func _on_ApproachBody_body_exited(body):
	#dairy.offline = true
	#print('exit')
	pass

func _on_InteractZone_body_entered(body):
	if body.is_in_group('Player'):
		body.use_e = true



func _on_InteractZone_body_exited(body):
	if body.is_in_group('Player'):
		body.use_e = false



func _on_ExitFade_body_exited(body):
	if body.is_in_group('Player'):
		$Ghost/Tera.queue_free()



