extends StaticBody2D

@onready var collision = $CollisionShape2D
@onready var sprite = $AnimatedSprite2D

var is_active = true

func press_switch():
	is_active = !is_active
	collision.set_deferred("disabled", !is_active)
	
	if is_active:
		sprite.frame = 0
	else:
		sprite.frame = 1
