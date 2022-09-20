extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func greeting():
	self.play("Idle")
	self.flip_h

func leave():
	self.play("Cast")
	$Blink.emitting = true
	$Delete.start()

func angry():
	self.play("Fist")
	self.flip_h = false
	

func _on_Delete_timeout():
	queue_free()
