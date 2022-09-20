extends KinematicBody2D


#stats

var health = 200
var armor = -20


#spells/summons

var lichblast = preload("res://Spells/LichBlast.tscn")
var seekerspell = preload("res://Spells/LichSeeker.tscn")
var bloodball = preload("res://Spells/LichSummon.tscn")

#aggro and behavior

var zombie_out = false #checks whether or not spell has been cast
var zombie_number = 0

var staggered = false #whether Lich has been interrupted by damage
var unstoppable = false #whether Lich can be interrupted by damage
var casting = false #whether Lich is currently casting a spell, should prevent casting of multiple spells
var cast_time_active = false

var tele_cooldown = false # when true prevents another teleport
var decide_teleport = false #whether Lich is about to teleport
var location_start = true #if true, means lich is at start position

var hurt = false

var conversing = false
var aggro = false #starts false
var serious_phase = false #starts false
var dying = false

signal ready_sconce
signal sconce_seeker
signal defeated

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
		aggro = false
		if dying == false:
			dying = true
			die()

func phase2():
	$Timers/TestTimer.wait_time = 2
	serious_phase = true

func take_damage(instigatorHitBox):
	var damageType = instigatorHitBox.owner.get_groups()[0]
	var damageTaken = instigatorHitBox.damage
	print("Boss Damage: ", damageTaken, "- armor", armor)
	damageTaken -= armor
	health -= damageTaken
	if serious_phase == false:
		if health <= 70:
			phase2()
			serious_phase = true
	hurting()
	print('hurt is ', hurt)
	
func die():
	$AnimatedSprite.play("Cast")
	emit_signal("defeated")
	$Timers/DyingRefresh.start()



func hurting():
	#flinching?
	$BoneDust.emitting = true
	if hurt == false:
		$Timers/HurtTimer.start()
		var coin = rng.randi_range(0,1)
		print('coin is: ', coin)
		if coin == 1:
			$Sounds/Crack1.play()
		if coin == 0:
			$Sounds/Crack2.play()
		hurt = true
	if hurt == true:
		if tele_cooldown == false:
			decide_teleport = true
			tele_cooldown = true
			$Timers/TeleCooldown.start()
			print('tele_cooldown is ', tele_cooldown)

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
	if dying == false:
		if casting == false:
			if hurt == false:
				$AnimatedSprite.play("Idle")
			elif hurt == true:
				$AnimatedSprite.play("Oof")
			if cast_time_active == false and hurt == false:
				$Timers/TestTimer.start() #timer determines time between casts
				cast_time_active = true
	else:
		$AnimatedSprite.play('Oof')

func SummonUndead():
	casting = true
	$Timers/SummonTimer.start()
	$Sounds/ChargeSeek.play()
	$AnimatedSprite.play("Point")
	$SomaticSpawn/BloodyCharge.emitting = true

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
	rng.randomize()
	var choice = rng.randi_range(1,3)
	print(choice)
	if choice == 1:
		print('lichblast')
		LichBlast()
	if choice == 2:
		if serious_phase == false:
			print('no spell yet')
		else:
			if zombie_out == false:
				SummonUndead()
			else:
				print('Summon already used!, casting other spell')
				LichBlast()
				zombie_out = false #resets so it can be cast again
	if choice == 3:
		print('seeker')
		SeekerCast()

# triggers lich spellcasting, should only trigger if aggroed, will choose spells
func _on_TestTimer_timeout():
	if aggro == true:
		if decide_teleport == true:
			print('Oh shit!')
			$Timers/TeleportTimer.start()
			$Blink.emitting = true
			$Sounds/Teleport.play()
		elif decide_teleport == false: 
			cast_spell()
			print('Lich is spellcasting!')


func _on_Area2D_body_entered(body):
	pass
	#if body.is_in_group("Player"):
		#aggro = true
		#print(aggro)
		#$Sounds/Crack1.play()


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



func _on_TeleportTimer_timeout():
	print("I'm getting the fuck out of here!!")
	if location_start == true:
		self.position.x = 7682
		self.position.y = -2166
		location_start = false
	else:
		self.position.x = 9087
		self.position.y = -2175
		location_start = true
	#cast_spell() weird double casting
	decide_teleport = false


func _on_TeleCooldown_timeout():
	tele_cooldown = false
	print('tele_cooldown is ', tele_cooldown)


func _on_DyingRefresh_timeout():
	$BoneDust.emitting = true
	$Sounds/Crack1.play()
	$Timers/DyingRefresh.start()


func _on_SummonTimer_timeout():
	$Sounds/ChargeSeek.stop()
	$Sounds/DischargeSeek.play() #add new sounds later?
	$SomaticSpawn/BloodyCharge.emitting = false
	var b = bloodball.instance()
	$SomaticSpawn.add_child(b)
	casting = false


func _on_Spawner_spawn_active():
	zombie_out = true
	zombie_number += 1




func _on_FinalWordZone_body_exited(body):
	if body.is_in_group("Player"):
		aggro = true
		print(aggro)
		$Sounds/Crack1.play()
