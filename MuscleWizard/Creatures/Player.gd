extends KinematicBody2D

# Health and wellness
var health = 20
export var isBusyReadingDialogue = false
export var jacked = false
var hurt = false

# Movement variables
export var moveSpeed = 400
var velocity = Vector2.ZERO

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
		queue_free()

### BASIC MAGIC ATTACK ###
var ArcaneProjectile = preload("res://Spells/ArcaneBlast.tscn")

signal shoot(bullet, direction, location)

func _input(event):
	if !isBusyReadingDialogue and event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("shoot", ArcaneProjectile, $AimIndicator.global_rotation, $Sprite/Staff/ProjectileOrigin.global_position)

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
	if isBusyReadingDialogue == false:
		handle_staff()
		$AimIndicator.look_at(get_global_mouse_position())

func _physics_process(_delta):
	if !isBusyReadingDialogue:
		move_player()

func handle_staff():
	match currentStaffState:
		staffStates.IN_HAND:
			if Input.is_action_pressed("ui_accept"):
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
				print("This wizard read his books! Apply the book buff!")


func _on_InteractableBase_talking():
	isBusyReadingDialogue = true
	print("start talking", isBusyReadingDialogue)
	pass # toggle spellcasting off


func _on_InteractableBase_stopped_talking():
	isBusyReadingDialogue = false
	print("stop talking", isBusyReadingDialogue)
	pass # toggle spellcasting on


func _on_Dummy_smashed():
	pass # Replace with function body.


func _on_HurtTimer_timeout():
	hurt = false
