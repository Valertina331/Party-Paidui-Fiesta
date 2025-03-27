extends CharacterBody2D
class_name Enemy

@export var enemy_health := 1 
@export var head_detection: Area2D 
@export var body_detection: Area2D
@export var uses_gravity := true

@onready var floor_check: RayCast2D = $RayCast2D


const death_Speed = -100
var fall = false
var collider
var bodycollider
var headcollider
var target_position: Vector2 = Vector2.ZERO
var player_direction := Vector2.ZERO


func _ready() -> void:
	head_detection.body_entered.connect(_on_head_touched)
	collider = $CollisionShape2D
	bodycollider = $HeadDetection/CollisionShape2D
	headcollider = $BodyDetection/CollisionShape2D
	
	if head_detection == null:
		print("ERROR: head_detection is missing in", self.name)
	else:
		print("head_detection found in", self.name)
	
func _physics_process(delta: float) -> void:
	if floor_check:
		var is_supported = floor_check.is_colliding()
		if uses_gravity and !is_supported and !fall:
			velocity.y += 800 * delta
			
	move_and_slide()
		
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision:
			var other = collision.get_collider()
			if other and other.is_in_group("Player"):
				if !fall:
					print("Enemy landed on player!")
					other.is_dead = true
	
	#$Sprite.play("walk")
		
	if velocity.x > 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
		
	if fall == true:
		position.y -= death_Speed * delta
		$AnimationPlayer.play("dead")
		_all_of_you_get_lost()

func _on_head_touched(body):
	if body.is_in_group("Player"):
		print("Player detected!")
		if body.global_position.y < global_position.y:
			if fall == false:
				body.bounce()
				print("Enemy killed by head stomp!")
				fall = true

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if fall == false:
			print("Player hit the enemy, dies!")
			body.is_dead = true
		
func _all_of_you_get_lost():
	collider.disabled = true
	bodycollider.disabled =true
	headcollider.disabled = true
	head_detection.monitoring = false
	head_detection.monitorable = false
	body_detection.monitoring = false
	body_detection.monitorable = false
