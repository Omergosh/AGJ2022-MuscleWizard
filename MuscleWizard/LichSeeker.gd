extends Node2D


onready var player = get_tree().get_nodes_in_group("Player")[0]
var rng = RandomNumberGenerator.new()
var type = 0
var velocity = Vector2()
var offset = Vector2()
export var moveSpeed = 2
var direction = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	#print('seeker active')
	rng.randomize()
	offset = Vector2(rng.randi_range(-90,90),rng.randi_range(-90,90))
	print(offset)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(player):
			var target = (offset + player.global_position)
			global_position = global_position.linear_interpolate(target, delta * moveSpeed)


func _on_Timer_timeout():
	$Swirl.visible = false
	$Expire.emitting = true
	#print('seeker timeout')
	queue_free()
