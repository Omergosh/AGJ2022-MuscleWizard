extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var entered_circle = false
var despawning = false
signal despawn
onready var timer = $"../Despawner"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if despawning == false:
		#if entered_circle == true:
			#timer.start()
			#emit_signal("despawn")






