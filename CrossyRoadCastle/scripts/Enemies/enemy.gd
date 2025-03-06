extends CharacterBody2D
class_name Enemy

@export var enemy_health := 1 
@export var head_detection: Area2D 

const death_Speed = -100
var fall = false

func _ready() -> void:
	head_detection.body_entered.connect(_on_head_touched)
	
	if head_detection == null:
		print("ERROR: head_detection is missing in", self.name)
	else:
		print("head_detection found in", self.name)
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	#if !is_on_floor():
		#velocity += get_gravity() * delta
	
	$Sprite.play("walk")
		
	if velocity.x > 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
		
	if fall == true:
		position.y -= death_Speed * delta

func _on_head_touched(body):
	if body.is_in_group("Player"):
		print("Player detected!")
		if body.global_position.y < global_position.y:
			body.bounce()
			print("Enemy killed by head stomp!")
			$AnimationPlayer.play("dead")
			fall = true
		else:
			body.is_dead = true
		

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Player hit the enemy, dies!")
		body.is_dead = true
