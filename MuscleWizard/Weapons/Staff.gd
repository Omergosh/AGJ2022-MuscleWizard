extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var activeHitbox = false
export var damage = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# a probably unnecessary function I'll delete if I don't end up needing it
#func End_Attack():
#	activeHitbox = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite/Hitbox.activeHitbox = activeHitbox
