extends Node2D


var exploded = false
var forming = true
var velocity = Vector2(700, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$FireForm2.play("Spark")
	$Fire.play("Fireball")
	$SummonTimer.start()

#straightline travel from staff, explode on contact.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if forming == false:
		if exploded == false:
			position += velocity * delta
	#print('exploded')
	#print(exploded)
	#print('not finished forming')
	#print(forming)

func _on_SummonTimer_timeout():
	forming = false
	$Fire.visible = true
	$FireForm2.visible = false


func _on_Explode_timeout():
	queue_free()


func _on_ExplosionTrigger_body_entered(body):
	if not body.is_in_group('Player'):
		$FireForm.visible = true
		$FireForm.play("Spark")
		$Fire.visible = false
		$Explode.start()
		exploded = true
		#print($Hitbox/CollisionShape2D.disabled)
		get_node('Hitbox/CollisionShape2D').disabled = false
		#print($Hitbox/CollisionShape2D.disabled)
		$Explosion.play()
		$BurnSound.stream_paused = true


func _on_Hitbox_body_entered(body):
	pass
