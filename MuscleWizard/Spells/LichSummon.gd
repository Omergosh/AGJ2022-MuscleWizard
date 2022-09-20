extends Node2D


# Declare member variables here. Examples:
var found_target = false #whether or not summon has found pentagram
onready var summon = get_tree().get_nodes_in_group("SummonCircle")[0]
export var moveSpeed = 1
var finished = false

onready var spellbody = $BloodBody
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target = summon.global_position
	global_position = global_position.linear_interpolate(target, delta * moveSpeed)
	if finished == false:
		if spellbody == null:
			finished = true
			$Despawner.start()








func _on_Despawner_timeout():
	queue_free()


func _on_Dier_timeout():
	queue_free()
