extends CharacterBody2D
class_name FloorEnemy

@export var enemy_health := 1 
@export var head_detection: Area2D 
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	head_detection.body_entered.connect(_on_head_touched)
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if velocity.length() > 0:
		$AnimatedSprite2D.play("default")
		
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true

func _on_head_touched(body):
	if body.is_in_group("Player"): 
		body.bounce()
		print("Enemy killed by head stomp!")
		queue_free() #Add animation & state later
