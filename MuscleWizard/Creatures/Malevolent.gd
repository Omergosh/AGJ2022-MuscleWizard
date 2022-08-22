extends KinematicBody2D


# Declare member variables here. Examples:
var health = 70
var aggro = false
var followphase = false
var chase = false
var cast = true
onready var moveSpeed = 1
onready var shadow = preload("res://Creatures/SquiggleAttack.tscn")
onready var spawnpoint = get_node("ShadowSpawn")
onready var spawnpoint2 = get_node("ShadowSpawn2")
onready var saydie = get_node("Attack1")
onready var sayperish = get_node("Attack2")
onready var player = get_node("../Player")
var rng = RandomNumberGenerator.new()
var toss = 0
signal victory
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_instance_valid(player):
		aggro = false
	if aggro == true:
		_attacking()
	if health <= 35 and chase == false:
		followphase = true
		chase = true
		_phase2()
	if followphase == true:
		if is_instance_valid(player):
			global_position = global_position.linear_interpolate(player.global_position, delta * moveSpeed)

func take_damage(instigatorHitBox):
	var damageType = instigatorHitBox.owner.get_groups()[0]
	var damageTaken = instigatorHitBox.damage
	print("Boss Damage: ", damageTaken)
	health -= damageTaken
	if health <= 0:
		$ShadeMelee.visible = false
		start_dying()
	
func _phase2():
	$Phase2.play()
	$ShadeMelee.visible = true
	$MeleeDelay.start()
	
func start_dying():
	followphase = false
	$Death.play()
	emit_signal('victory')
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
	var d = shadow.instance()
	spawnpoint.add_child(p)
	p.type = toss
	spawnpoint2.add_child(d)
	d.type = toss
	p.rotation = p.direction
	d.rotation = d.direction
	$Body.play("BodyIdle")


func _on_Spook2_body_entered(body):
	pass


func _on_BossTrigger_body_entered(body):
	aggro = true
	print('angy')


func _on_MeleeDelay_timeout():
	get_node("ShadeMelee/Hitbox/CollisionShape2D").disabled = false
	$ShadeMelee.play("GreyVines")
	$VineActive.start()

func _on_VineActive_timeout():
	get_node("ShadeMelee/Hitbox/CollisionShape2D").disabled = true
	$ShadeMelee.play("VineRetract")
	$MeleeDelay.start()
