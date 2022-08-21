extends KinematicBody2D

export var moveSpeed = 200
var health = 10
var damage = 5
var dead = false
var alive = true
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

func take_damage(instigatorHitBox):
	var _damageType = instigatorHitBox.owner.get_groups()[0]
	var damageTaken = instigatorHitBox.damage
	print("Damage: ", damageTaken)
	health -= damageTaken
	
	var p = bloodParticles.instance()
	var delta = instigatorHitBox.global_position - global_position
	get_parent().add_child(p)
	p.global_position = global_position
	p.look_at(global_position - delta)
	p.emitting = true
	
	if health <= 0:
		start_dying()

func start_dying():
	# play sound effects + animations,
	# then call finish_dying at end of animation
	finish_dying()

# Remove enemy from level
func finish_dying():
	queue_free()

#Shambler sight radius stuff
func _on_Sight_body_entered(body):
	if body.is_in_group("Player"):
		aggro = true


func _on_Sight_body_exited(body):
	if body.is_in_group("Player"):
		aggro = false
