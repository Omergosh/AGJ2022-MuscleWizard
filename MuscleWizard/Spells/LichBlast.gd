extends Node2D

var popped = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2(1000, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if popped == false:
		position += velocity * delta

func _on_DespawnBox_body_entered(body):
	if body.is_in_group("Lich"):
		pass
	else:
		popped = true
		$ArcaneBubble.play("Pop")
		$Pop.play()
		$Despawn.start()


func _on_StartTime_timeout():
	$Hitbox/CollisionShape2D.set_deferred("disabled", false)


func _on_Despawn_timeout():
	queue_free()
