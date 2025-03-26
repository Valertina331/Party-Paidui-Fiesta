extends Node

#This dictionary is what will call all the characters post character selection

var playersPlaying  = {}

# Everything here needs to be saved in Json
var levelsProgressed = 0
var goldCoin = clamp(0, 0, 1000)
var purpleCoin = 0
var heartsActive = 3
var availableCharacters = 6 # Only two for testing purposes change to reflect full character list
var readyplayers = 0

var is_paused: bool = false :
	set(value):
		is_paused = value
		get_tree().paused = is_paused
var current_menu_stack: Array = []  

#Early Implementation may delete later
var tower_to_call
var typePrefix = ".tscn"
var towerintforjson : int
#Booleans to save when characters are unlocked will flesh out more later

#For buying hearts only do not touch
var coins_deducted = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func push_menu(menu_node: Control):
	current_menu_stack.push_back(menu_node)
	
func pop_menu():
	if current_menu_stack.size() > 0:
		current_menu_stack.pop_back().queue_free()

func input(event):
	if event.is_action_pressed("start"):
		handle_esc_action()
	for device in range(4):
		if MultiplayerInput.is_action_just_pressed(device, "start"):
			handle_esc_action()
		
	
func handle_esc_action():
	if Global.current_menu_stack.is_empty():
		show_pause_menu()
	else:
		handle_menu_back()

func show_pause_menu():
	var pause_menu = preload("res://scenes/pause_menu.tscn").instantiate()
	get_tree().root.add_child(pause_menu)
	Global.is_paused = true

func handle_menu_back():
	if Global.current_menu_stack.size()> 0:
		var current_menu = Global.current_menu_stack.back()
		if current_menu.has_method("_on_back_pressed"):
			current_menu._on_back_pressed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Setting up foundation for vairables that will need to be accessed
# Character Selection Done via a sheet, frame # will determine character
# Frame # will always be the main way of determining whats what stored as characterChoice
# Device stores the device used to play
# PlayerNumber is repetitive but dont want to break it
func add_to_dict(key: String, characterChoice: int, playerNumber: int, device : int):
	playersPlaying[key] = {
		"characterChoice": characterChoice,
		"device": device,
		"playerNumber": playerNumber,
		}
		
		
func get_entry(key:String) -> Dictionary:
	if playersPlaying.has(key):
		return playersPlaying[key]
	return {}

#Will use for deleting a choice
func remove_entry(key: String):
	if playersPlaying.has(key):
		var dropped_player_number = playersPlaying[key]["playerNumber"]
		playersPlaying.erase(key)
		
		var new_dict = {}
		var new_number = 1
		
		for player_key in playersPlaying.keys():
			var player_data = playersPlaying[player_key]
			if player_data["playerNumber"] > dropped_player_number:
				player_data["playerNumber"] = new_number
				new_dict[str(new_number)] = player_data
				new_number +=1
			else:
				new_dict[player_key] = player_data
#All of these functions exist soleley for returning info for levels

func get_current_yellow_coins():
	return goldCoin

func get_current_purple_coins():
	return purpleCoin	
	
func get_coins_deducted():
	return coins_deducted
	
func reset_coins_deducted():
	coins_deducted = 0
	return coins_deducted
	
func leftTower():
	levelsProgressed = 0
	return levelsProgressed
	
func change_yellow_coins(val: int):
	goldCoin += val
	
func change_purple_coins(val: int):
	purpleCoin += val
	
func change_coins_deducted(val:int):
	coins_deducted += val

func add_to_floor_climbed(val):
	levelsProgressed += val

func get_levels_climbed():
	return levelsProgressed
	
func get_current_health():
	return heartsActive
	
func change_health(val):
	heartsActive += val
	return heartsActive

func change_ready_players(val):
	readyplayers += val
	return readyplayers
	
func get_ready_players():
	return readyplayers

func freshStart():
	heartsActive = 3
	return heartsActive

#switch on for testing
func debugtest():
	add_to_dict("1", 0, 1, -1)

#Method that combines to tell godot to start at level 1 of tower
func tower_Choice(val):
	match val:
		0: 
			tower_to_call = "res://Javid/"
			towerintforjson = 0
			return tower_to_call
		1: 
			tower_to_call = "res://Valentina/"
			towerintforjson = 1
			return tower_to_call
		2: 
			tower_to_call = "res://Xiaowei/"
			towerintforjson = 2
			return tower_to_call
