extends Node2D


# Declare member variables here. Examples:
var health = 50
var dead = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		if dead == false:
			$Open.play()
			$DeathTime.start()
			dead = true

func take_damage(instigatorHitBox):
	var _damageType = instigatorHitBox.owner.get_groups()[0]
	var damageTaken = instigatorHitBox.damage
	print("Damage: ", damageTaken)
	health -= damageTaken
	$SolidSound.play()


func _on_DeathTime_timeout():
	print('walldead')
	self.queue_free()
