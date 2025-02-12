extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body):
	print("+1")
	animation_player.play("CollectedAnimation")
