extends Node2D

onready var player = get_node("../Player")

var health = 15
var active = true

var charging = false
var seekerspell = preload("res://Spells/LichSeeker.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active == true:
		if health <= 0:
			active = false
			$FocalPoint/Broken.emitting = true
			$AnimatedSprite.play("Broken")
			$FocalPoint/Break.play()
	pass

func take_damage(instigatorHitBox):
	var damageType = instigatorHitBox.owner.get_groups()[0]
	var damageTaken = instigatorHitBox.damage
	print('SconceDamage, ', damageTaken)
	health -= damageTaken
	#hurt sound?


func _on_Lich_ready_sconce():
	if active == true:
		$FocalPoint/GatherPower.visible = true
		$FocalPoint/ChargeSeek.playing = true
	else:
		print("Lich sconce is broken and cannot cast!")

func _on_Lich_sconce_seeker():
	if active == true:
		$FocalPoint/GatherPower.visible = false
		$FocalPoint/ChargeSeek.playing = false
		$FocalPoint/Cast.emitting = true
		var s = seekerspell.instance()
		$FocalPoint.add_child(s)
	else:
		$FocalPoint/GatherPower.visible = false
		$FocalPoint/ChargeSeek.playing = false
		
	
