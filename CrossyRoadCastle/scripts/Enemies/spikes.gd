extends Area2D


func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Player hit the spike, dies!")
		body.is_dead = true
