extends KinematicBody2D

# Health and wellness
export var health = 20
export var isBusyReadingDialogue = false

export var jacked = false
export var smart = false

var hurt = false
var alive = true


# Movement variables
export var moveSpeed = 400
var velocity = Vector2.ZERO

#staff variables
var staff_upgrade = false

#spells known
var denied_knowledge = false
var pyromancy = false #should be false at start
var abjure = false
var arcane = true

var warded = false #used for abjuration spell

var ghostquest = false #accepting ghost power
#cooldowns
var cooldown = false #arcane cooldown
var swinging = false #swingsound
var fire_cooldown = false #fireball cooldown

#hud
onready var hud = $Camera2D/HUD
var use_e = false

# Staff / weapon variables
enum staffStates {IN_HAND, SWINGING}
export var currentStaffState = staffStates.IN_HAND
var staffOffset

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.play("IdleThin")
	staffOffset = $Sprite/StaffHold/Staff.position
	var _error = connect("shoot", self, "_on_Player_shoot")
	var _conflag = connect('spark', self, "_on_Player_fireball") #copying omer's code on shooting for fireball. it jank. im bad at this
	loadPlayerChoices()

func take_damage(instigatorHitBox):
	var damageType = instigatorHitBox.owner.get_groups()[0]
	var damageTaken = instigatorHitBox.damage
	if warded == false:
		health -= damageTaken
		if hurt == false:
			$Ouch.play()
			$HurtTimer.start()
			hurt = true
	if warded == true:
		$Ward/WardSound.play()
		warded = false
		$Ward.emitting = false
	if health <= 0:
		GameManager.alive = false
		SceneTransition.transitionTo("res://UI/EndingWIP.tscn")

### BASIC MAGIC ATTACK ###
var ArcaneProjectile = preload("res://Spells/ArcaneBlast.tscn")

signal shoot(bullet, direction, location)

func _input(event):
	if !isBusyReadingDialogue and event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and cooldown == false:
			cooldown = true
			$CastDelay.start()
			$SpellBlast.play()
			$Sprite/StaffHold/Staff/ProjectileOrigin/ArcaneBubble.visible = true
			$Sprite/StaffHold/Staff/ProjectileOrigin/ArcaneBubble.play("Form")
			
		
func _on_Player_shoot(_bullet, direction, location):
	var p = ArcaneProjectile.instance()
	owner.add_child(p)
	p.rotation = direction
	p.position = location
	p.velocity = p.velocity.rotated(direction)


### Fire magic attack ###
var FireBall = preload('res://Spells/Fireball.tscn')

signal spark(ball, direction, location)

func _on_Player_fireball(_ball, direction, location):
	var b = FireBall.instance()
	owner.add_child(b)
	b.rotation = direction
	b.position = location
	b.velocity = b.velocity.rotated(direction)

func _cast_pose():
	if jacked == true:
		$Sprite.play("CastBuff")
	if jacked == false:
		$Sprite.play("CastThin")
	$Sprite.position.x = -60
	isBusyReadingDialogue = true

### STAFF ATTACK + MOVEMENT ###

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(isBusyReadingDialogue)
	#print(swinging)
	#print(cooldown)
	_check_interact()
	if isBusyReadingDialogue == false:
		handle_staff()
		$AimIndicator.look_at(get_global_mouse_position())
	_update_hud()
	_check_spells()
	if not Input.is_action_pressed("ui_accept"):
		swinging = false
	if swinging == false:
		$whack.play()
		$whack.stream_paused = true
	if swinging == true:
		$whack.stream_paused = false
	if pyromancy == true:
		if fire_cooldown == false:
			if Input.is_action_just_pressed("fireball"):
				emit_signal("spark", FireBall, $AimIndicator.global_rotation, $Sprite/StaffHold/Staff/ProjectileOrigin.global_position)
				fire_cooldown = true
				$FireDelay.start()
				_cast_pose()
	if abjure == true:
		if warded == false:
			if Input.is_action_just_pressed("ward"):
				fire_cooldown = true
				$FireDelay.start()
				$Ward.emitting = true
				$Ward/WardSound.play()
				warded = true
				_cast_pose()


func _physics_process(_delta):
	if !isBusyReadingDialogue:
		move_player()

func handle_staff():
	match currentStaffState:
		staffStates.IN_HAND:
			if Input.is_action_pressed("ui_accept"):
				swinging = true
				currentStaffState = staffStates.SWINGING
				$AnimationPlayer.play("StaffSwing")
				$Sprite/StaffHold/Staff/AnimationPlayer.play("bonk")

		#staffStates.SWINGING:
			#$Staff.position.x += 5
			#$Staff.rotation += 2
			#pass

# Called from within animations to say, let us know when the staff is done being swung
func Set_Staff_State(newStaffState: int):
	currentStaffState = newStaffState

func move_player():
	var newVelocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		newVelocity.x -= moveSpeed
		set_player_facing_direction(true)
	if Input.is_action_pressed("move_right"):
		set_player_facing_direction(false)
		newVelocity.x += moveSpeed
	if Input.is_action_pressed("move_up"):
		newVelocity.y -= moveSpeed
	if Input.is_action_pressed("move_down"):
		newVelocity.y += moveSpeed
	velocity = newVelocity
	var _moveData = move_and_slide(velocity)

func set_player_facing_direction(facingLeft: bool):
	#$Sprite.flip_h = facingLeft
	if currentStaffState == staffStates.IN_HAND:
		$Sprite.scale.x = -0.5 if facingLeft else 0.5
		#scale.x = -1 if facingLeft else 1
		#var newStaffX = staffOffset.x + (staffOffset.x * -2 * int(facingLeft))
		#$Sprite/Staff.position.x = newStaffX
signal ReadPyro

func loadPlayerChoices():
	for choice in GameManager.playerChoices:
		match choice:
			"WentToGym":
				$Sprite.play("IdleBuff")
				if health > 40:
					pass
				else:
					health = 40
				jacked = true
				print("This wizard went to the gym! Apply the gym buff!")
			"StudiedBooks":
				$CastTimer.wait_time = 0.3
				smart = true
				print("This wizard read his books! Apply the book buff!")
			"LearnPyro":
				pyromancy = true
				emit_signal("ReadPyro")
				print("This wizard learned forbidden knowledge!")
				isBusyReadingDialogue = false
			"Leave":
				denied_knowledge = true
				print("This wizard denied forbidden knowledge!")
				isBusyReadingDialogue = false
			"AcceptWard":
				ghostquest = true
				abjure = true
				isBusyReadingDialogue = false
				print("This wizard learned a spell of abjuration!")
			"RejectWard":
				print("This wizard refused the help of ancient magi")
				isBusyReadingDialogue = false

#checks spells known for HUD
func _check_spells():
	if pyromancy == true:
		hud.pyro = true
	if abjure == true:
		hud.abjur = true
	if arcane == true:
		hud.arcane = true

func equip_longer_staff():
	# Enable LongStaff
	$Sprite/StaffHold/LongStaff.visible = true
	var ball_spawn = $Sprite/StaffHold/Staff/ProjectileOrigin
	$Sprite/StaffHold/Staff.remove_child(ball_spawn)
	$Sprite/StaffHold/LongStaff.add_child(ball_spawn)
	#remove_child($Sprite/Staff)
	
	$Sprite/StaffHold/Staff.set_name("Blungus")
	$Sprite/StaffHold/Blungus.visible = false
	
	# Rename LongStaff to Staff
	$Sprite/StaffHold/LongStaff.set_name("Staff")
	pass

func _on_InteractableBase_talking():
	isBusyReadingDialogue = true
	print("start talking", isBusyReadingDialogue)
	pass # toggle spellcasting off


func _on_InteractableBase_stopped_talking():
	isBusyReadingDialogue = false
	print("stop talking", isBusyReadingDialogue)
	pass # toggle spellcasting on

func _update_hud():
	hud.hp = health
	hud.pyro = pyromancy
	hud.abjur = abjure
	hud.arcane = arcane

func _on_Dummy_smashed():
	pass # Replace with function body.

func _check_interact():
	if use_e == true:
		hud.e = true
	if use_e == false:
		hud.e = false
		

func _on_HurtTimer_timeout():
	hurt = false

#timer resets cooldown on arcane blast
func _on_CastTimer_timeout():
	cooldown = false

#timer triggers arcane blast effect
func _on_CastDelay_timeout():
	emit_signal("shoot", ArcaneProjectile, $AimIndicator.global_rotation, $Sprite/StaffHold/Staff/ProjectileOrigin.global_position)
	$Sprite/StaffHold/Staff/ProjectileOrigin/ArcaneBubble.play("Bubble")
	$CastTimer.start()
	$Sprite/StaffHold/Staff/ProjectileOrigin/ArcaneBubble.visible = false


func _on_FireDelay_timeout():
	fire_cooldown = false
	if jacked == true:
		$Sprite.play("IdleBuff")
	if jacked == false:
		$Sprite.play("IdleThin")
	$Sprite.position.x = 0
	isBusyReadingDialogue = false

func swap_staff():
	if staff_upgrade == false:
		equip_longer_staff()
		$PickupSound.play()
		staff_upgrade = true


func _on_InteractableBase2_talking():
	isBusyReadingDialogue = true
	print("start talking", isBusyReadingDialogue)
	pass # toggle spellcasting off


func _on_InteractableBase2_stopped_talking():
	isBusyReadingDialogue = false
	print("stop talking", isBusyReadingDialogue)
	pass # toggle spellcasting on


func _on_Help_stopped_talking():
	isBusyReadingDialogue = false
	print("stop talking", isBusyReadingDialogue)
	pass # toggle spellcasting on


func _on_Help_talking():
	isBusyReadingDialogue = true
	print("start talking", isBusyReadingDialogue)
	pass # toggle spellcasting off


func _on_Shun_stopped_talking():
	isBusyReadingDialogue = false
	print("stop talking", isBusyReadingDialogue)
	pass # toggle spellcasting on


func _on_Shun_talking():
	isBusyReadingDialogue = true
	print("start talking", isBusyReadingDialogue)
	pass # toggle spellcasting off


func _on_Smart_stopped_talking():
	isBusyReadingDialogue = false
	print("stop talking smart diary", isBusyReadingDialogue)
	pass # toggle spellcasting on


func _on_Smart_talking():
	isBusyReadingDialogue = true
	print("start talking smart diary", isBusyReadingDialogue)
	pass # toggle spellcasting off


func _on_Buff_stopped_talking():
	isBusyReadingDialogue = false
	print("stop talking buff diary", isBusyReadingDialogue)
	pass # toggle spellcasting on


func _on_Buff_talking():
	isBusyReadingDialogue = true
	print("start talking buff diary", isBusyReadingDialogue)
	pass # toggle spellcasting off





func _on_TestWeapon_body_entered(body):
	if body.is_in_group("Player"):	
		swap_staff()
			#staff_upgrade = true
	
	#used to test powerup, using to see if workaround for dialogue


func _on_SmartStaff_talking():
	isBusyReadingDialogue = true
	print("start talking smart staff", isBusyReadingDialogue)


func _on_BuffStaff_stopped_talking():
	isBusyReadingDialogue = false
	print("stop talking buff staff equip, playerside", isBusyReadingDialogue)
	#swap_staff()
	

func _on_BuffStaff_talking():
	isBusyReadingDialogue = true
	print("start talking buff staff", isBusyReadingDialogue)


func _on_SmartStaff_stopped_talking():
	isBusyReadingDialogue = false
	print("stop talking smart staff", isBusyReadingDialogue)
	





func _on_BossTalkBuff_talking():
	isBusyReadingDialogue = true
	print("start talking buff boss", isBusyReadingDialogue)


func _on_BossTalkBuff_stopped_talking():
	isBusyReadingDialogue = false
	print("stop talking buff boss", isBusyReadingDialogue)



func _on_BossTalkSmart_stopped_talking():
	isBusyReadingDialogue = false
	print("stop talking smart boss", isBusyReadingDialogue)


func _on_BossTalkSmart_talking():
	isBusyReadingDialogue = true
	print("start talking smart boss", isBusyReadingDialogue)
	


func _on_QuestInsult_talking():
	isBusyReadingDialogue = true
	print("start talking insultboss", isBusyReadingDialogue)

func _on_PyroComment_talking():
	isBusyReadingDialogue = true
	print("start talking pyroboss", isBusyReadingDialogue)

func _on_PyroComment_stopped_talking():
	isBusyReadingDialogue = false
	print("stop talking pyroboss", isBusyReadingDialogue)


func _on_QuestInsult_stopped_talking():
	isBusyReadingDialogue = false
	print("start talking insult", isBusyReadingDialogue)


func _on_VictoryBuff_stopped_talking():
	isBusyReadingDialogue = false
	print("stop talking buff victory", isBusyReadingDialogue)


func _on_VictoryBuff_talking():
	isBusyReadingDialogue = true
	print("start talking buff victory", isBusyReadingDialogue)


func _on_VictorySmart_stopped_talking():
	isBusyReadingDialogue = false
	print("stop talking smart victory", isBusyReadingDialogue)


func _on_VictorySmart_talking():
	isBusyReadingDialogue = true
	print("start talking buff victory", isBusyReadingDialogue)
