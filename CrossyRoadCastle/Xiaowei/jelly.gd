extends Area2D

@export var jump_height := 160.0
@export var bounce_cooldown: float = 0.5
@onready var animation_player: AnimationPlayer = $AnimationPlayer 
var can_bounce := true

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("detected")
		var jump_velocity = -sqrt(2 * gravity * jump_height)
		body.velocity.y = jump_velocity 
		body.move_and_slide()
		if animation_player:
			animation_player.play("bounce") 
		can_bounce = false
		await get_tree().create_timer(bounce_cooldown).timeout
		can_bounce = true
