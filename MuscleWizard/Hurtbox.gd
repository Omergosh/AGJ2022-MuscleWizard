class_name Hurtbox
extends Area2D

export var is_player_hurtbox = false

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	var _error = connect("area_entered", self, "_on_area_entered")

func _on_area_entered(hitbox: Hitbox) -> void:
	if hitbox == null:
		return
	if hitbox.is_player_attack == is_player_hurtbox:
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox)

