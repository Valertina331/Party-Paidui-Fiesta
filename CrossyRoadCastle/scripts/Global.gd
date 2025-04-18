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
var sidemenu = false
var playerFreeze = false

var is_paused: bool = false :
	set(value):
		is_paused = value
		get_tree().paused = is_paused
		AudioServer.set_bus_mute(0, false) if !is_paused else null
		print("Global Pause State: ", is_paused)
var current_menu_stack: Array = []  

#Early Implementation may delete later
var tower_to_call
var tower_bgm_path
var typePrefix = ".tscn"
var towerintforjson : int
#Booleans to save when characters are unlocked will flesh out more later

#Save and Load
const SAVE_PATH = "user://save_game.dat"  

func save_game():
	var save_data = {
		"gold_coin": goldCoin,
		"levels_progressed": levelsProgressed,
		"hearts_active": heartsActive,
		"tower_progress": tower_max_levels
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		print(SAVE_PATH)
	else:
		push_error("Save failed: ", FileAccess.get_open_error())

func load_game():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var save_data = file.get_var()
			goldCoin = save_data.get("gold_coin", 0)
			heartsActive = save_data.get("hearts_active", 3)
			print("save is load")			
			tower_max_levels = save_data.get("tower_progress", {0:1, 1:1, 2:1})
			print(tower_max_levels)
		else:
			push_error("Saving failed: ", FileAccess.get_open_error())
	else:
		print("No save file")

#Save For Tower
var tower_max_levels = {
	0: 1,
	1: 1,
	2: 1
}
func update_tower_max_level(tower_id: int, new_level: int):
	if tower_max_levels.get(tower_id, 0) < new_level:
		tower_max_levels[tower_id] = new_level
		save_game()

#PauseMenu Part
func input(event):
	if event.is_action_pressed("start"):
		handle_esc_action()
	for device in range(4):
		if MultiplayerInput.is_action_just_pressed(device, "start"):
			handle_esc_action()

func handle_esc_action():
	if not current_menu_stack.is_empty():
		pop_menu()
	else:
		toggle_pause()
		
func toggle_pause():
	is_paused = !is_paused
	if is_paused:
		var pause_menu = preload("res://scenes/pause_menu.tscn").instantiate()
		get_tree().root.add_child(pause_menu)
		push_menu(pause_menu)
	else:
		pop_menu()
		

func push_menu(menu_node: Node):
	current_menu_stack.push_back(menu_node)

func pop_menu():
	if current_menu_stack.size() > 0:
		var last_menu = current_menu_stack.pop_back()
		if is_instance_valid(last_menu):
			last_menu.queue_free()
	if current_menu_stack.size() > 0:
		var current_menu = current_menu_stack.back()
		if is_instance_valid(current_menu):
			current_menu.show()
	else:
		is_paused = false



#For buying hearts only do not touch
var coins_deducted = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



		
	

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
	save_game()
	
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

func gave_up():
	readyplayers = 0
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
			#change your own bgm here!
			tower_bgm_path = "res://assets/BGM/EasterTower.mp3"
			towerintforjson = 0
			return tower_to_call
		1: 
			tower_to_call = "res://Valentina/"
			tower_bgm_path = "res://assets/BGM/EasterTower.mp3"
			towerintforjson = 1
			return tower_to_call
		2: 
			tower_to_call = "res://Xiaowei/"
			#change your own bgm here!
			tower_bgm_path = "res://assets/BGM/EasterTower.mp3"
			towerintforjson = 2
			return tower_to_call
