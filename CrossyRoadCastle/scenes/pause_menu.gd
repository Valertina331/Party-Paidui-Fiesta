extends Control  
@onready var control_button: Button = $PanelContainer/VBoxContainer/Control
func _ready():
	Global.push_menu(self)
	hide()
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
func _on_control_pressed():
	var controls_menu = preload("res://scenes/control_panel.tscn").instantiate()
	get_tree().root.add_child(controls_menu)
	Global.push_menu(controls_menu)
	hide()

func _on_back_to_game():
	Global.is_paused = false
	queue_free()
