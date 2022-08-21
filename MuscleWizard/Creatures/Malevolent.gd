extends KinematicBody2D


# Declare member variables here. Examples:
var health = 50
var aggro = true
var cast = true
onready var shadow = preload("res://Creatures/SquiggleAttack.tscn")
onready var spawnpoint = get_node("ShadowSpawn")
onready var saydie = get_node("Attack1")
onready var sayperish = get_node("Attack2")
var rng = RandomNumberGenerator.new()
var toss = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if aggro == true:
		_attacking()

func take_damage(damageTaken, damageType):
	print("Boss Damage: ", damageTaken)
	health -= damageTaken
	if health <= 0:
		start_dying()
	

func start_dying():
	$Death.play()
	# then call finish_dying at end of animation
	$AnimationPlayer.play("Death")
	pass

# Remove enemy from level
func finish_dying():
	queue_free()

func _attacking():
	if cast == false:
		$AttackTimer.start()
		if toss >= 0:
			saydie.play()
		if toss < 0:
			sayperish.play()
		cast = true
		$AnimTimer.start()
		$Body.play("Cast")
	

func _on_AttackTimer_timeout():
	rng.randomize()
	toss = rng.randf_range(-2,2)
	cast = false


func _on_AnimTimer_timeout():
	var p = shadow.instance()
	spawnpoint.add_child(p)
	p.rotation = p.direction
	$Body.play("BodyIdle")
