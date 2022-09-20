extends Node2D


var bossdialogue_started = false
var last_words_chosen = false
var last_words_spoken = false
var death_words_spoken = false

onready var player = get_node("../Player")

var insult = false #quest comment will not be made unless true
var pyronote = false #pyro comment will not be made unless true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if bossdialogue_started == false:
		if body.is_in_group('Player'):
			$FalseLich.greeting()
			bossdialogue_started = true
			if player.pyromancy == true:
				pyronote = true
			if player.ghostquest == true:
				insult = true


func _on_FinalWordZone_body_entered(body):
	if last_words_chosen == false:
		if body.is_in_group('Player'):
			pass
			if insult == true:
				$FalseLich.angry()
			last_words_chosen = true


func _on_FinalWordZone_body_exited(body):
	if last_words_spoken == false:
		if body.is_in_group('Player'):
			$FalseLich.leave()
			if $PyroComment != null:
				$PyroComment.queue_free()
			if $QuestInsult != null:
				$QuestInsult.queue_free()
			last_words_spoken = true
