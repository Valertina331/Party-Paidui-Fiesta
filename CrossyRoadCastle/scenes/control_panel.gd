extends Control

var return_target: Control 
@onready var back_button: Button = $Panel/Button
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(event):
	if event.is_action_pressed("cancel"):
		_close_panel()
		get_viewport().set_input_as_handled()

func _close_panel():
	Global.pop_menu()
	print(Global.is_paused)
	queue_free()
	
