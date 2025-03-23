extends CharacterBody2D

@export var drop_height: float = 300.0  
@export var gravity: float = 980.0    
@export var detection_radius: float = 150.0 

var is_activated := false
var initial_position: Vector2
var should_fall := false

@onready var detection_area = $DropDetection
@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D

func _ready():
	initial_position = global_position
	set_physics_process(false)
	visible = false
	collision_shape.disabled = true
	
	var area_shape = CircleShape2D.new()
	area_shape.radius = detection_radius
	detection_area.get_node("CollisionShape2D").shape = area_shape

func _physics_process(delta):
	if should_fall:
		velocity.y += gravity * delta
		move_and_slide()
		
		if is_on_floor():
			should_fall = false
			velocity = Vector2.ZERO

func _on_detection_area_body_entered(body):
	if body.name == "Player" && !is_activated:
		activate_fall()

func activate_fall():
	is_activated = true
	visible = true
	collision_shape.disabled = false
	global_position = initial_position - Vector2(0, drop_height)
	set_physics_process(true)
	should_fall = true

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Player hit the enemy, dies!")
		body.is_dead = true
