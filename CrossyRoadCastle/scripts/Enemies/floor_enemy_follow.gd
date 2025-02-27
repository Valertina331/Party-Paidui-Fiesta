extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D
@export var move_speed := 50.0
var player: CharacterBody2D = null

func Enter():
	var players = get_tree().get_nodes_in_group("Player")
	var closest_player = null
	var closest_distance = INF
	
	#only consider players visible, 
	#may change this func if the logic of multiplayer is changed
	for p in players:
		if !p.is_dead: 
			var distance = enemy.global_position.distance_to(p.global_position)
			print(distance)
			if distance < closest_distance:
				closest_distance = distance
				closest_player = p

	player = closest_player
	if player:
		print("Enemy targeting:", player.name)
	else:
		print("No valid players found")
		Transitioned.emit(self, "Idle")
	
func Physics_Update(delta: float):
	if player == null or player.is_dead:
		Transitioned.emit(self, "Idle")
		return
		
	var direction = player.global_position - enemy.global_position
			
	#stop when nearest enough to the player
	if direction.length() > 25:
		enemy.velocity.x = direction.normalized().x * move_speed
	else:
		enemy.velocity = Vector2()
		
	if direction.length() > 400:
		Transitioned.emit(self, "idle")
