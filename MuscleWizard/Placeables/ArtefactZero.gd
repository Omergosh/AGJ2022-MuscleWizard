extends Node2D


var triggered = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("Artefactidle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group('Player'):
		if triggered == false:
			$AnimatedSprite.play('Dull')
			body.health += 5
			$Sound.play()
			triggered = true
		if triggered == true:
			print('Already used artefact!')
