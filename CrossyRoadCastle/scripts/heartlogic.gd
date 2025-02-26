extends Control

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _lost_heart():
	animated_sprite_2d.play("lost")
	
func _full_heart():
	animated_sprite_2d.play("full")
