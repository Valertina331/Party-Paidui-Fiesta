extends Area2D


var gravity_multiplier: float = 0.5

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.gravity_multiplier = 0.05
	


func _on_body_exited(body):
	if body.is_in_group("Player"):
		body.gravity_multiplier = 1
