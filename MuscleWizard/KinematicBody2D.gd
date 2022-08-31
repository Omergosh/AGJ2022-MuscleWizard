extends KinematicBody2D


#stats

var health = 200
var armor = 2


#spells/summons

var lichblast = preload("res://Spells/LichBlast.tscn")

#aggro and behavior

var staggered = false #whether Lich has been interrupted by damage
var unstoppable = false #whether Lich can be interrupted by damage
var casting = false #whether Lich is currently casting a spell, should prevent casting of multiple spells


var hurt = false

var conversing = false
var aggro = false
var serious_phase = false

signal ready_sconce
signal sconce_seeker

onready var player = get_node("../Player")

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	IdlePose()
	if health <= 0:
		print('lichdead')
		queue_free()

func take_damage(instigatorHitBox):
	var damageType = instigatorHitBox.owner.get_groups()[0]
	var damageTaken = instigatorHitBox.damage
	print("Boss Damage: ", damageTaken, "- armor", armor)
	damageTaken -= armor
	health -= damageTaken

func LichBlast():
	var player_position = player.position
	casting = true
	$AnimatedSprite.play("Cast")
	#right
	$RightSpawn/RightHand.look_at(player_position)
	$RightSpawn/LichBubble.visible = true
	$RightSpawn/LichBubble.play("Form")
	#left
	$LeftSpawn/LeftHand.look_at(player_position)
	$LeftSpawn/LichBubble.visible = true
	$LeftSpawn/LichBubble.play("Form")
	
	$Timers/BlastTimer.start()
	
func IdlePose():
	if casting == false:
		$AnimatedSprite.play("Idle")


func _on_BlastTimer_timeout():
	var b = lichblast.instance()
	var b2 = lichblast.instance()
	#right and left cast animation set to invisible
	#LichBlasts are spawned
	$RightSpawn/LichBubble.visible = false
	$RightSpawn/RightHand.add_child(b)
	$LeftSpawn/LichBubble.visible = false
	$LeftSpawn/LeftHand.add_child(b2)
	$Sounds/BlastCast.play()
	
	casting = false


func _on_TestTimer_timeout():
	if aggro == true:
		LichBlast()


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		aggro = true
		print(aggro)
		$Sounds/Crack1.play()
