extends Node2D


var voice1 = false
var voice2 = false
onready var exit = get_node("Portal")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Spook1_body_entered(body):
	if voice1 == false:
		$Voice1.play()
		voice1 = true


func _on_Spook2_body_entered(body):
	if voice2 == false:
		$Voice2.play()
		voice2 = true


func _on_Malevolent_victory():
	exit.visible = true
	$Wall/BossMusic.stop()
	$VictorySound.play()
	exit.monitoring = true



