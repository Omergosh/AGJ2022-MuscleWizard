extends Node2D


# Declare member variables here. Examples:
onready var aura = get_node("Aura")
onready var centre = get_node('Centre')
onready var blockcollision = get_node("Blocker/CollisionShape2D")
onready var hitcollision = get_node("Hitbox/CollisionShape2D")
# Called when the node enters the scene tree for the first time.
var damage_tick = false
var on = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func activate():
	aura.emitting = true
	centre.visible = true
	blockcollision.set_deferred("disabled", false)
	$DamageTimer.start()

func deactivate():
	queue_free()

func _on_DamageTimer_timeout():
	if damage_tick == false:
		hitcollision.disabled = false
		aura.emitting = true
		$Burst.play()
		damage_tick = true
	else:
		hitcollision.disabled = true
		damage_tick = false


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		if on == false:
			print('Walls Active!')
			on = true
			activate()


func _on_Lich_defeated():
	deactivate()
