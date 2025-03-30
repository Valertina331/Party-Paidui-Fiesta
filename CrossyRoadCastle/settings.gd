extends Control

var return_target: Control 
@onready var back_button: Button = $Panel/Button
@onready var volume_slider: HSlider = $Panel/MarginContainer/VBoxContainer/HSlider
@onready var mute_checkbox: CheckBox = $Panel/MarginContainer/VBoxContainer/CheckBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button.pressed.connect(_on_button_pressed)
	process_mode = Node.PROCESS_MODE_ALWAYS
	var current_db = AudioServer.get_bus_volume_db(0)
	volume_slider.value = remap(current_db, -30.0, 0.0, 0.0, 100.0)
	mute_checkbox.button_pressed = AudioServer.is_bus_mute(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_h_slider_value_changed(value: float) -> void:
	#AudioServer.set_bus_volume_db(0,value/5)
	var actual_db = remap(value, 0.0, 100.0, -30.0, 0.0)
	AudioServer.set_bus_volume_db(0, actual_db)
	print("Volume", actual_db, " dB") 


func _on_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)




func _on_button_pressed() -> void:
	Global.pop_menu()
	print(Global.is_paused)
	queue_free()
