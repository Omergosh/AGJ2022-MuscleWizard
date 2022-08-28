extends KinematicBody2D

export var moveSpeed = 200
var health = 10
var damage = 5
var dead = false
var alive = true
var hurt = false
var aggro = false
var direction = 0
onready var player = get_node("../Player")
var velocity = Vector2()
export(PackedScene) var bloodParticles

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if dead == false:
		if not is_instance_valid(player):
			aggro = false
		if alive == true and aggro == true:
			direction = (player.position - position).normalized()
			var _moveData = move_and_slide(direction * moveSpeed)
			$AnimationPlayer.play("Attack")
			if player.position.x < position.x:
				$Sprite.scale.x = -1
			elif player.position.x > position.x:
				$Sprite.scale.x = 1
		else:
			$AnimationPlayer.play("Idle")
			pass
	if dead == true:
		aggro = false

func take_damage(instigatorHitBox):
	var _damageType = instigatorHitBox.owner.get_groups()[0]
	var damageTaken = instigatorHitBox.damage
	print("Damage: ", damageTaken)
	health -= damageTaken
	if hurt == false and dead == false:
		$HurtTime.start()
		hurt = true
		$Hurt.play() 
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

#Shambler sight radius stuff
func _on_Sight_body_entered(body):
	if body.is_in_group("Player") and dead == false:
		aggro = true
		$Aggro.play()


func _on_Sight_body_exited(body):
	if body.is_in_group("Player"):
		aggro = false


func _on_HurtTime_timeout():
	hurt = false
