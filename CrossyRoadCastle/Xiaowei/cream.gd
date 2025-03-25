extends CharacterBody2D

@export var disappear_delay: float = 1.0    # 触发后消失时间
@export var respawn_time: float = 3.0      # 重生时间
@export var fade_duration: float = 0.5     # 渐隐动画时长

@onready var collision = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var area = $DetectionArea
var initial_position: Vector2
var is_active := true

func _ready():	
	initial_position = global_position
	

func _on_body_entered(body):
	if body.name == "Player" && is_active:
		start_disappear()

func start_disappear():
	is_active = false
	timer.start(disappear_delay) 
func _on_timer_timeout():
	create_tween()\
		.tween_property(sprite, "modulate:a", 0.0, fade_duration)\
		.set_ease(Tween.EASE_IN)\
		.finished.connect(_on_fade_completed)
func _on_fade_completed():
	collision.set_deferred("disabled", true)
	await get_tree().create_timer(respawn_time).timeout
	reset_platform()
func reset_platform():
	is_active = true
	collision.set_deferred("disabled", false)
	sprite.modulate.a = 1.0
