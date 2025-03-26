extends Control  

var is_paused = false
@onready var save: Button = $PanelContainer/VBoxContainer/Save

func _ready():
	Global.push_menu(self)
	hide()

func _on_pause_requested(device):
	_toggle_pause()

func _unhandled_input(event):
	if event.is_action_pressed("start"):
		_toggle_pause()
	for device in range(4):
		if MultiplayerInput.is_action_just_pressed(device, "start"):
			_toggle_pause()
		else:
			return
		
func _toggle_pause():
	get_tree().paused = !get_tree().paused
	if get_tree().paused == true:
		visible = true
		save.grab_focus()
	if get_tree().paused == false:
		visible = false


func _on_exit_pressed():
	Global.playersPlaying.clear()
	Global.leftTower()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_save_pressed():
	Global.save_game()
	
	
	
