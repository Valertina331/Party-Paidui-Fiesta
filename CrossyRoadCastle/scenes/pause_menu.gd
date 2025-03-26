extends Control  

var is_paused = false




func _on_pause_requested(device):
	_toggle_pause()

func _unhandled_input(event):
	if event.is_action_pressed("start"):
		_toggle_pause()

func _toggle_pause():
	get_tree().paused = !get_tree().paused
	if get_tree().paused == true:
		visible = true
	if get_tree().paused == false:
		visible = false


func _on_exit_pressed():
	Global.playersPlaying.clear()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
