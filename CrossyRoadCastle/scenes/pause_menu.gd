extends Control  

var is_paused = false
@onready var save: Button = $PanelContainer/VBoxContainer/Save
@onready var control_button: Button = $PanelContainer/VBoxContainer/Control
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
		
func pause():
	print("Game Paused")
	get_tree().paused = true  
	show()

func testEsc():	
	if Input.is_action_just_pressed("cancel") and !get_tree().paused:
		print("Test1")
		pause() 
	elif Input.is_action_just_pressed("cancel") and get_tree().paused:
		print("Test2")
		resume() 
func _process(delta: float):
	testEsc()

func _on_exit_pressed():
	Global.playersPlaying.clear()
	Global.leftTower()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
func resume():	
	print("Game Resumed")
	get_tree().paused = false 
	hide()

func _on_control_pressed():
	var controls_menu = preload("res://scenes/control_panel.tscn").instantiate()
	get_tree().root.add_child(controls_menu)
	Global.push_menu(controls_menu)
	hide() 

func _on_back_to_game():
	Global.is_paused = false
	queue_free()


func _on_save_pressed() -> void:
	Global.save_game()
