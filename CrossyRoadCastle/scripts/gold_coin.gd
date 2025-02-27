extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(body):
	
	if body.is_in_group("Player"):
		Global.change_yellow_coins(+1)
		animation_player.play("CollectedAnimation")
	
