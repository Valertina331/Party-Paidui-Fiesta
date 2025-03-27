extends Area2D
class_name RabbitHole

@onready var sound = $AudioStreamPlayer2D

@export var linked_hole: Area2D  #paired rabbit hole

var is_ready = true

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if !is_ready:
		return
	
	if body.is_in_group("Player") or body.is_in_group("Enemy"):
		if linked_hole:
			#close the hole temp so player won't be sent back immidiately
			linked_hole.is_ready = false

			#send player to the paired rabbit hole
			body.global_position = linked_hole.global_position + Vector2(0, -16)
			sound.play()
			
			#open the rabbit hole
			await get_tree().create_timer(0.2).timeout
			linked_hole.is_ready = true
