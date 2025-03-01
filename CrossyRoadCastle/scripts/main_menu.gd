extends Control

#I know this is super repetitive but it kept getting a bug I couldnt figure out how to solve
@onready var player_containers: GridContainer = $PlayerContainers
const PLAYER_SELECT = preload("res://scenes/player_select.tscn")


var device: int #This is to be stored in the player so the individual controllers can change the character
var playersPlaying = [] #This is necessary just for gathering players together, but true value is stored in dictionary
var devicesin = [] #This stops the repeating of devices
var updated = false

#Function to get all available playable devices on computer
func get_unjoined_devices():
	var devices = Input.get_connected_joypads()
	devices.append(-1)
	return devices


func _process(fixed):
	_multiplayer_setup()
	get_unjoined_devices()
	
	
#Start button logic, can create safegaurd for everyone to say ready first
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Valentina/1.tscn")
	


#Essentially takes all the devices and the moment someone hits A, or enter will add them as a player, assuming the device hasnt already been used
func _multiplayer_setup():
	for i in get_unjoined_devices():
		if MultiplayerInput.is_action_just_pressed(i, "jump"):
			if !devicesin.has(i):
				devicesin.append(i)
				playerjoin(i)
		if MultiplayerInput.is_action_just_pressed(i, "start"):
			if devicesin.has(i):
				_on_play_button_pressed()

#This is saying hey, if the player size isnt 4, create a player, add it to the people playing, give it this value and placement and add it visually to the screen
func playerjoin(device):
	if playersPlaying.size() <4 :
		var player = PLAYER_SELECT.instantiate()
		playersPlaying.append(player)
		
		var available_number = 1
		var taken_numbers = playersPlaying.map(func(p): return p.playerNumber)
		while available_number in taken_numbers:
			available_number +=1
		
		player.playerNumber = available_number
		player.device = device
		player.characterChoice = 0
		
		player_containers.add_child(player)
		player.connect("imout", Callable(self, "_on_im_out"))
			
		Global.add_to_dict(str(player.playerNumber), player.characterChoice, player.playerNumber, player.device)
		print(Global.playersPlaying)
			

#When this signal is detected removes player and device from arrays then updates number in code
func _on_im_out(value):
		var player_to_remove = null
		for player in playersPlaying:
			if player.device == value:
				player_to_remove = player
				break
				
		if player_to_remove:
			player_to_remove.queue_free()
			playersPlaying.erase(player_to_remove)
			devicesin.erase(value)
			
			
		var key_to_remove = null
		for key in Global.playersPlaying.keys():
			if Global.playersPlaying[key]["device"] == value:
				key_to_remove = key
				break
		if key_to_remove:
			Global.remove_entry(key_to_remove)
			_update_player_numbers()
		

#This is for updating UI needed chatgpt help
func _update_player_numbers():
	for i in range(playersPlaying.size()):
		var new_number = i + 1
		playersPlaying[i].playerNumber = new_number
		playersPlaying[i]._update_UI(new_number)
		Global.playersPlaying[str(new_number)] = {
		"characterChoice": playersPlaying[i].characterChoice,
		"device": playersPlaying[i].device,
		"playerNumber": new_number
		}
