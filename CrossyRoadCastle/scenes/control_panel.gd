extends Control

var return_target: Control 
@onready var back_button: Button = $Panel/Button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if back_button:
		print("Find it!")
		if $Panel/Button.pressed.connect(_on_back_pressed) != OK:
			push_error("Failed")
		else:
			print("Yes!")
	else:
		push_error("Not find it")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup_return_target(target: Control):
	return_target = target
func _on_back_pressed():
	print("Worked")
	print(return_target)
	if return_target != null:
		return_target.show()
	Global.pop_menu()
	queue_free()
