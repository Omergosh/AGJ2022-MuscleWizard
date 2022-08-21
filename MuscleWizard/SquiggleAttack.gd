extends Node2D

onready var player = get_tree().get_nodes_in_group("Player")[0]
var rng = RandomNumberGenerator.new()
var type = 0
var velocity = Vector2()
export var moveSpeed = 1
var direction = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	type = rng.randf_range(-1,1)
	if type >=0:
		$ShadowBolt.play("Fly1")
	if type <0:
		$ShadowBolt.play("Fly2")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#direction = (player.position - position).normalized()
	global_position = global_position.linear_interpolate(player.global_position, delta * moveSpeed)
	#velocity = direction

func _on_Timer_timeout():
	queue_free()
