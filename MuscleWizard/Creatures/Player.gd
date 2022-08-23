extends KinematicBody2D

# Health and wellness
export var health = 20
export var isBusyReadingDialogue = false
export var jacked = false
var hurt = false
var alive = true


# Movement variables
export var moveSpeed = 400
var velocity = Vector2.ZERO

#spells known
var pyromancy = false
var abjure = false
var arcane = true
#cooldowns
var cooldown = false #arcane cooldown
var swinging = false #swingsound

#hud
onready var hud = $Camera2D/HUD
var use_e = false

# Staff / weapon variables
enum staffStates {IN_HAND, SWINGING}
export var currentStaffState = staffStates.IN_HAND
var staffOffset

# Called when the node enters the scene tree for the first time.
func _ready():
	staffOffset = $Sprite/Staff.position
	var _error = connect("shoot", self, "_on_Player_shoot")
	loadPlayerChoices()

func take_damage(instigatorHitBox):
	var damageType = instigatorHitBox.owner.get_groups()[0]
	var damageTaken = instigatorHitBox.damage
	health -= damageTaken
	if hurt == false:
		$Ouch.play()
		$HurtTimer.start()
		hurt = true
	if health <= 0:
		GameManager.alive = false
		SceneTransition.transitionTo("res://UI/EndingWIP.tscn")
		queue_free()
### BASIC MAGIC ATTACK ###
var ArcaneProjectile = preload("res://Spells/ArcaneBlast.tscn")

signal shoot(bullet, direction, location)

func _input(event):
	if !isBusyReadingDialogue and event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and cooldown == false:
			cooldown = true
			$CastDelay.start()
			$SpellBlast.play()
			$Sprite/Staff/ProjectileOrigin/ArcaneBubble.visible = true
			$Sprite/Staff/ProjectileOrigin/ArcaneBubble.play("Form")
			
		
func _on_Player_shoot(_bullet, direction, location):
	var p = ArcaneProjectile.instance()
	owner.add_child(p)
	p.rotation = direction
	p.position = location
	p.velocity = p.velocity.rotated(direction)

### STAFF ATTACK + MOVEMENT ###

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(isBusyReadingDialogue)
	#print(swinging)
	_check_interact()
	if isBusyReadingDialogue == false:
		handle_staff()
		$AimIndicator.look_at(get_global_mouse_position())
	_update_hud()
	if not Input.is_action_pressed("ui_accept"):
		swinging = false
	if swinging == false:
		$whack.play()
		$whack.stream_paused = true
	if swinging == true:
		$whack.stream_paused = false
		

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
				$Sprite/Staff/AnimationPlayer.play("bonk")

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

func loadPlayerChoices():
	for choice in GameManager.playerChoices:
		match choice:
			"WentToGym":
				$Sprite.play("IdleBuff")
				health += 10
				
				print("This wizard went to the gym! Apply the gym buff!")
			"StudiedBooks":
				$CastTimer.wait_time = 0.3
				print("This wizard read his books! Apply the book buff!")


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
	emit_signal("shoot", ArcaneProjectile, $AimIndicator.global_rotation, $Sprite/Staff/ProjectileOrigin.global_position)
	$Sprite/Staff/ProjectileOrigin/ArcaneBubble.play("Bubble")
	$CastTimer.start()
	$Sprite/Staff/ProjectileOrigin/ArcaneBubble.visible = false
