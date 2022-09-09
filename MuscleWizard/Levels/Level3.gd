extends Node2D


# Declare member variables here. Examples:
# var a = 2
onready var player = $Player
var diary_set = false

signal set1
signal set2
signal set3

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	_check_pyro()
	set_traps()
	set_traps()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_diary():
	if player.jacked == true:
		$ExplorerDiary/Smart.queue_free()
		$StaffGrade/SmartStaff.queue_free() 
		$StaffGrade/InteractZone.queue_free() #deletes 'press e to interact' prompt since buffwizard just auto interacts here
	if player.smart == true:
		$ExplorerDiary/Buff.queue_free()
		$StaffGrade/TestWeapon.queue_free() 
		$StaffGrade/BuffStaff.queue_free()

func _check_pyro():
	if $Player.pyromancy == true:
		get_node("Ghost/Tera/Help").queue_free()
	if $Player.pyromancy == false:
		get_node("Ghost/Tera/Shun").queue_free()

func set_traps():
	var trap = rng.randi_range(1,3)
	print(trap)
	if trap == 1:
		emit_signal("set1")
	if trap == 2:
		emit_signal("set2")
	if trap == 3:
		emit_signal("set3")

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









func _on_Pickup_timeout():
	print('deleted staff, level code')
	$StaffGrade.queue_free()





func _on_CharredSkull_delete_interact():
	$PyroSkull/CharredSkull/InteractZone.queue_free()


func _on_TestWeapon_body_entered(body):
	if body.is_in_group('Player'):
		print('delet timer for staff')
		$StaffGrade/TestWeapon/Pickup.start()
