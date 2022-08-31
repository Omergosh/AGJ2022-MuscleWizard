extends KinematicBody2D

export var moveSpeed = 200
var health = 20
var damage = 6

var armor = 2

var dead = false
var alive = true
var hurt = false
var aggro = false
var direction = 0
var swing_speed = 1

onready var stigma = get_node("../Gauntlet/Stigma")
#a place for aggroed mobs that don't see the player to move to

var triggered = true
signal smells_blood

var swinging = false 
#only attacks when within certain radius

var random_time = 1
var rng = RandomNumberGenerator.new()
var sound_chosen = false
onready var sound = get_node('Aggro')

onready var player = get_node("../Player")
var velocity = Vector2()
#export(PackedScene) var bloodParticles
var bloodParticles = preload("res://Creatures/BloodParticles.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if dead == false:
		if not is_instance_valid(player):
			aggro = false
			direction = (Vector2(2566,3) - position).normalized()
			var _moveData = move_and_slide(direction * moveSpeed)
		moveSpeed = (25 * (20/health) + 200)
		if alive == true and aggro == true:
			#print(player.global_position)
			direction = (player.global_position - global_position).normalized()
			var _moveData = move_and_slide(direction * moveSpeed)
			swing_speed = 1 + (0.1 * (20/health))
			$AnimationPlayer.playback_speed = swing_speed
			if swinging == true:
				$AnimationPlayer.play("Attack")
			if swinging == false:
				$AnimationPlayer.play("Walk")
			if player.global_position.x < global_position.x:
				$Sprite.scale.x = -1
			elif player.global_position.x > global_position.x:
				$Sprite.scale.x = 1
		else:
			$AnimationPlayer.play("Idle")
			pass
	if dead == true:
		aggro = false

func take_damage(instigatorHitBox):
	var _damageType = instigatorHitBox.owner.get_groups()[0]
	var damageTaken = instigatorHitBox.damage
	print("Damage: ", damageTaken, 'minus armor', armor)
	damageTaken -= armor
	health -= damageTaken
	aggro = true
	if hurt == false and dead == false:
		$HurtTime.start()
		hurt = true
		#$Hurt.play() #no hurt sound for now
	var p = bloodParticles.instance()
	var delta = instigatorHitBox.global_position - global_position
	get_parent().add_child(p)
	p.global_position = global_position
	p.look_at(global_position - delta)
	p.emitting = true
	
	if health <= 0:
		start_dying()

func start_dying():
	if dead == false:
		$Moan1.play()
	# then call finish_dying at end of animation
		dead = true
		$CollisionShape2D.disabled = true
		$Sprite/Corpse.visible = true
		$Sprite/ShamblerSprite.visible = false
	finish_dying()
#having them remain as static death images didn't work as intended and I havent fixed it yet
# so I've kept in the queue free death for now
# Remove enemy from level
func finish_dying():
	queue_free()

func sound_choice():
	#print(random_time)
	rng.randomize()
	random_time = rng.randf_range(1.1,4)
	if random_time < 2 and random_time >= 0:
		sound = get_node("Anger2")
	if random_time < 3 and random_time >= 2:
		sound = get_node("Anger1")
	if random_time < 3.5 and random_time >= 4:
		sound = get_node("Aggro")
	#print(sound)
	$RandomSound.wait_time = random_time
	$RandomSound.start()
	sound_chosen = true

#Shambler sight radius stuff
func _on_Sight_body_entered(body):
	if body.is_in_group("Player") and dead == false:
			player = body
			aggro = true
			#print('aggro')
			#print(aggro)
			if sound_chosen == false:
				sound_choice()


func _on_Sight_body_exited(body):
	if body.is_in_group("Player"):
		#aggro = false
		pass
		#bloody shamblers remain aggroed


func _on_HurtTime_timeout():
	hurt = false





func _on_Swinger_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("smells_blood")
		swinging = true


func _on_Swinger_body_exited(body):
	if body.is_in_group("Player"):
		$Swinger/SwingerReset.start()


func _on_SwingerReset_timeout():
	swinging = false
	#print(triggered)
	#print(aggro)


func _on_RandomSound_timeout():
	sound.play()
	sound_chosen = false
