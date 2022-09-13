extends KinematicBody2D


#stats

var health = 200
var armor = 2


#spells/summons

var lichblast = preload("res://Spells/LichBlast.tscn")
var seekerspell = preload("res://Spells/LichSeeker.tscn")

#aggro and behavior

var staggered = false #whether Lich has been interrupted by damage
var unstoppable = false #whether Lich can be interrupted by damage
var casting = false #whether Lich is currently casting a spell, should prevent casting of multiple spells
var cast_time_active = false

var hurt = false

var conversing = false
var aggro = false #starts false
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
	hurting()
	print('hurt is ', hurt)
	


func hurting():
	#flinching?
	if hurt == false:
		$Timers/HurtTimer.start()
		var coin = rng.randi_range(0,1)
		print('coin is: ', coin)
		if coin == 1:
			$Sounds/Crack1.play()
		if coin == 0:
			$Sounds/Crack2.play()
		hurt = true

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
	
	
func SeekerCast():
	casting = true
	emit_signal("ready_sconce")
	$Timers/SeekerTimer.start()
	$Sounds/ChargeSeek.play()
	$AnimatedSprite.play("RockOn")
	$SomaticSpawn/PinkCharge.emitting = true

func IdlePose():
	if casting == false:
		$AnimatedSprite.play("Idle")
		if cast_time_active == false:
			$Timers/TestTimer.start() #timer determines time between casts
			cast_time_active = true




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

func cast_spell():
	var choice = rng.randi_range(1,3)
	print(choice)
	if choice == 1:
		print('lichblast')
		LichBlast()
	if choice == 2:
		print('no spell yet')
	if choice == 3:
		print('seeker')
		SeekerCast()

# triggers lich spellcasting, should only trigger if aggroed, will choose spells
func _on_TestTimer_timeout():
	if aggro == true:
		cast_spell()
		print('Lich is spellcasting!')


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		aggro = true
		print(aggro)
		$Sounds/Crack1.play()


func _on_HurtTimer_timeout():
	hurt = false
	print('hurt is ', hurt)

func _on_SeekerTimer_timeout():
	$Sounds/ChargeSeek.stop()
	$Sounds/DischargeSeek.play()
	var s = seekerspell.instance()
	$SomaticSpawn/PinkCharge.emitting = false
	$SomaticSpawn.add_child(s)
	emit_signal("sconce_seeker")
	casting = false
	cast_time_active = false

