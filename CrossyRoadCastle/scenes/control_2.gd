extends Node2D

var previous_menu: Control = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
