extends AnimatedSprite

#script for book reading
var read = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.play("Runes")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_ReadPyro():
	self.play("Blank")
	$Timer.start()
	$Knawledge.play()


func _on_Timer_timeout():
	queue_free()
