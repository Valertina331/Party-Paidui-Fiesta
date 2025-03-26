extends Node2D

signal switch_trigger

@onready var area = $Area2D
@onready var sprite = $AnimatedSprite2D
@onready var click_sound = $AudioStreamPlayer2D

var is_pressed = false

func _ready() -> void:
	area.body_entered.connect(_on_area_2d_body_entered)
	
func _process(delta) -> void:
	if is_pressed:
		sprite.frame = 1
	else:
		sprite.frame = 0

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		print("press!")
		switch_trigger.emit()
		is_pressed = !is_pressed
		click_sound.play()
