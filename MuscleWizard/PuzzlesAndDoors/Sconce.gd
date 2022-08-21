extends Node2D


# Declare member variables here. Examples:
# var a = 2
var health = 1
var lit = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health = lerp(health, 2, 0.01)
	print(health)
	if health > 1:
		lit = false
	if lit == false:
		$Hurtbox/Lit.visible = false
	if lit == true:
		$Hurtbox/Lit.visible = true

func take_damage(damageTaken):
	print("Damage: ", damageTaken)
	health -= damageTaken
	if health <= 0:
		if lit == false:
			$On.play()
		lit = true
