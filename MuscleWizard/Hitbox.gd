class_name Hitbox
extends Area2D

export var damage := 5
export var magic = true
export var is_player_attack = true

func _init() -> void:
	collision_layer = 2
	collision_mask = 0
