extends StaticBody2D


# Declare member variables here. Examples:
var closed = false
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BossTrigger_body_entered(body):
	position.x = 1919
	position.y = 4736
	if closed == false:
		$Close2.play()
		closed = true
