extends Node2D


# Declare member variables here. Examples:
var attack = false
var sprung = false
var active = false
onready var bs = preload("res://Creatures/BloodyShambler.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attack == true:
		if sprung == false:
			activate()
			sprung = true

func activate():
	if active == true:
		$Door.play()
		var b = bs.instance()
		self.add_child(b)
		$StaticBody2D.queue_free()




func _on_Area2D_body_entered(body):
	if body.is_in_group('Player'):
		attack = true
