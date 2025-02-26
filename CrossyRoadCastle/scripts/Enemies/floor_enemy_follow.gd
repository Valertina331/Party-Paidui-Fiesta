extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D
@export var move_speed := 50.0
var player: CharacterBody2D

func Enter():
	var players = get_tree().get_nodes_in_group("Player")
	var closest_player = null
	var closest_distance = INF
	
	#only consider players visible, 
	#may change this func if the logic of multiplayer is changed
	for p in players:
		if p.visible: 
			var distance = enemy.global_position.distance_to(p.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_player = p

	player = closest_player
	
func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	
	if direction.length() > 25:
		enemy.velocity = direction.normalized() * move_speed
	else:
		enemy.velocity = Vector2()
		
	if direction.length() > 50:
		Transitioned.emit(self, "idle")
