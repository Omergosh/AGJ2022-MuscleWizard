extends KinematicBody2D


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
	connect("shoot", self, "_on_Player_shoot")
	pass # Replace with function body.

### BASIC MAGIC ATTACK ###
var ArcaneProjectile = preload("res://Spells/ArcaneBlast.tscn")

signal shoot(bullet, direction, location)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("shoot", ArcaneProjectile, $AimIndicator.global_rotation, $Sprite/Staff/ProjectileOrigin.global_position)

func _on_Player_shoot(bullet, direction, location):
	var p = ArcaneProjectile.instance()
	owner.add_child(p)
	p.rotation = direction
	p.position = location
	p.velocity = p.velocity.rotated(direction)
	print("shooting")

### STAFF ATTACK + MOVEMENT ###

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_staff()
	$AimIndicator.look_at(get_global_mouse_position())

func _physics_process(delta):
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
	move_and_slide(velocity)

func set_player_facing_direction(facingLeft: bool):
	#$Sprite.flip_h = facingLeft
	if currentStaffState == staffStates.IN_HAND:
		$Sprite.scale.x = -0.5 if facingLeft else 0.5
		#scale.x = -1 if facingLeft else 1
		#var newStaffX = staffOffset.x + (staffOffset.x * -2 * int(facingLeft))
		#$Sprite/Staff.position.x = newStaffX
