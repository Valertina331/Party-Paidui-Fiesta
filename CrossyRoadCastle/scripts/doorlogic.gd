extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

signal levelpassed

var doortype

func _ready():
	doortype = get_parent().name
	print(doortype)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if doortype == "DoorEntered":
			print("poop")
		if doortype == "DoorToAdvance":
			emit_signal("levelpassed")
			animated_sprite_2d.play("open")
			body.queue_free()
