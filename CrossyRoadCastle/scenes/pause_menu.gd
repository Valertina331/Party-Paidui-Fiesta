extends Control  
@onready var resumeb: Button = $PanelContainer/VBoxContainer/Resume
var is_paused = false

func resume():
	print("Game Resumed")
	get_tree().paused = false 
	hide()

func pause():
	print("Game Paused")
	get_tree().paused = true  
	show()

func testEsc():	
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		print("Test1")
		pause() 
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		print("Test2")
		resume() 
func _process(delta: float):
	testEsc()

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
		resumeb.grab_focus()
	if get_tree().paused == false:
		visible = false


func _on_exit_pressed():
	Global.playersPlaying.clear()
	Global.leftTower()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_resume_pressed() -> void:
	resume()


func _on_save_pressed() -> void:
	Global.save_game()
