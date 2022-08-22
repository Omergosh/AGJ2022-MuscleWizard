extends Node2D


# Declare member variables here. Examples:
# var a = 2
var health = 1
var lit = false
var doorsent = false
signal keys
signal lock

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	health = lerp(health, 2, 0.005)
	if health > 1:
		lit = false
	if lit == false:
		if doorsent == true:
			emit_signal("lock")
			doorsent = false
			$Hurtbox/Particles2D.emitting = false
		$Hurtbox/Lit.visible = false
	if lit == true:
		$Hurtbox/Lit.visible = true
		if doorsent == false:
			emit_signal("keys")
			doorsent = true

func take_damage(instigatorHitBox):
	var damageType = instigatorHitBox.owner.get_groups()[0]
	var damageTaken = instigatorHitBox.damage
	if damageType == 'Magic':
		health -= damageTaken
	if health <= 0:
		if lit == false:
			$On.play()
			$Hurtbox/Particles2D.emitting = true
		lit = true
