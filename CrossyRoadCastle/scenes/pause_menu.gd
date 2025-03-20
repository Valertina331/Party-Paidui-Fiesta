extends Control  

func _ready():
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
