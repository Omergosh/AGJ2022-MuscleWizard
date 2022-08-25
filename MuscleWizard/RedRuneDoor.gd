extends Node2D

var health = 10
var armor = 4
signal bashed
signal unlocked
var keyholeleft = 0
var keyholeright = 0
var unlocked = false
var open = false
signal magicicalburst
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_set_sprite()
	if keyholeright + keyholeleft == 4:
		unlocked = true
		$AnimatedSprite.play('Open')
		if open == false:
			$Open.play()
			open = true
		_opening()
		
func take_damage(instigatorHitBox):
	var damageType = instigatorHitBox.owner.get_groups()[0]
	var damageTaken = instigatorHitBox.damage
	damageTaken -= armor
	print(damageTaken)
	if damageType == 'Physical':
		health -= damageTaken
		print(health)
	if damageType == 'Magic':
		health += 1
		print(health)
		emit_signal("magicicalburst")
		$EatMagic.emitting = true
		$EatMagicSound.play()
	
	if health <= 0:
		if open == false:
			$Open.play()
		_opening()
		
func _opening():
	$Timer.start()

func _set_sprite():
	var holesum = keyholeleft + keyholeright
	#print(holesum)
	if open == false:
		if holesum < 2:
			$AnimatedSprite.play("Closed")
		if holesum == 4:
			$AnimatedSprite.play('Open')
			pass
		if holesum >= 2:
			if keyholeleft == 2:
				$AnimatedSprite.play("LeftLit")
			if keyholeright == 2:
				$AnimatedSprite.play("RightLit")
				

func _on_Timer_timeout():
	queue_free()


func _on_CrystalSconce_keys():
	keyholeright += 1


func _on_CrystalSconce_lock():
	keyholeright -= 1


func _on_CrystalSconce2_keys():
	keyholeright += 1


func _on_CrystalSconce2_lock():
	keyholeright -=1


func _on_CrystalSconce3_keys():
	keyholeleft +=1


func _on_CrystalSconce3_lock():
	keyholeleft -=1


func _on_CrystalSconce4_keys():
	keyholeleft +=1


func _on_CrystalSconce4_lock():
	keyholeleft -=1
