extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var prepared_spawn = false
var zombie = preload("res://Creatures/BloodyShambler.tscn")

signal spawn_active

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func spawn_undead():
	if prepared_spawn == false:
		var z = zombie.instance()
		$Summon.emitting = true
		self.add_child(z)
		emit_signal("spawn_active")
		#prepared_spawn = true

func _on_Area2D_body_entered(body):
	print(body)
	if body.is_in_group('SpawnProjectile'):
		print('spawning!')
		spawn_undead()
		body.queue_free()
		
