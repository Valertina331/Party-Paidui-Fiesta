extends State
class_name Attack

@export var enemy: CharacterBody2D
@export var attack_speed := 200.0

func Enter():
	var anim = enemy.get_node("Sprite")
	anim.play("detect")

func Physics_Update(delta: float):
	var dir = Vector2(enemy.target_position.x - enemy.global_position.x, 0).normalized()
	enemy.velocity = dir * attack_speed
	enemy.move_and_slide()

	if abs(enemy.global_position.x - enemy.target_position.x) < 10:
		print("STOP")
		Transitioned.emit(self, "Walk")
