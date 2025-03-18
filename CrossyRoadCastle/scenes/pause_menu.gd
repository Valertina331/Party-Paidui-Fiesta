extends Control  

@onready var save_button: Button = $Panel/VBoxContainer/Save
@onready var load_button: Button = $Panel/VBoxContainer/Load
@onready var control_button: Button = $Panel/VBoxContainer/Control
@onready var credit_button: Button = $Panel/VBoxContainer/Credit
@onready var exit_button: Button = $Panel/VBoxContainer/Exit
func _ready():
	hide()

func _on_resume_pressed():
	get_tree().paused = false  
	hide()

func _on_restart_pressed():
	get_tree().reload_current_scene()  

func toggle_pause():
	if visible:
		hide()
		get_tree().paused = false
	else:
		show()
		get_tree().paused = true 

func _on_quit_pressed():
	get_tree().quit()  


func _on_control_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/control_panel.tscn")


func _on_credit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credit_panel.tscn")
