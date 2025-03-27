extends State
class_name Attack

@export var enemy: CharacterBody2D
@export var attack_speed := 6000.0
@export var attack_distance := 6500.0

var dir := Vector2.ZERO
var distance_traveled := 0.0
var is_attacking

func Enter():
	enemy.get_node("Sprite").play("attack")
	
	if enemy.player_direction != null:
		dir = enemy.player_direction
	else:
		dir = Vector2(1, 0)
	dir = dir.normalized()
	distance_traveled = 0.0
	is_attacking = true

func Physics_Update(delta: float):
	if !is_attacking:
		enemy.velocity = Vector2.ZERO
		return
		
	var move_x = dir.x * attack_speed * delta
	enemy.velocity.x = move_x
	enemy.move_and_slide()
	
	distance_traveled += abs(move_x * delta)
	
	if distance_traveled >= attack_distance:
		print("STOP")
		enemy.velocity = Vector2.ZERO
		is_attacking = false
		Transitioned.emit(self, "Walk")
