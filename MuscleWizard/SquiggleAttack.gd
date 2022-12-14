extends Node2D

onready var player = get_tree().get_nodes_in_group("Player")[0]
var rng = RandomNumberGenerator.new()
var type = 0
var velocity = Vector2()
export var moveSpeed = 2
var direction = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	print(type)
	if type >=0:
		$ShadowBolt.play("Impact1")
	if type <0:
		$ShadowBolt.play("Impact2")
	#randomized animations don't work yet


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(player):
		global_position = global_position.linear_interpolate(player.global_position, delta * moveSpeed)
	#velocity = direction

func _on_Timer_timeout():
	queue_free()





func _on_PlayerHurter_body_entered(body):
	if body.is_in_group('Player'):
		$Timer2.start()
		pass
	else:
		pass


func _on_Timer2_timeout():
	queue_free()
