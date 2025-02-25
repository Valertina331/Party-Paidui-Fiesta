extends Control

#I know this is super repetitive but it kept getting a bug I couldnt figure out how to solve
@onready var player_containers: GridContainer = $PlayerContainers
const PLAYER_SELECT = preload("res://scenes/player_select.tscn")


var maxvalue = 2

var device: int #This is to be stored in the player so the individual controllers can change the character
var playersPlaying = [] #This data will be transferred to global so that every level should know how many players to spawn
var devicesin = [] #This stops the repeating of devices

#Function to get all available playable devices on computer
func get_unjoined_devices():
	var devices = Input.get_connected_joypads()
	devices.append(-1)
	
	return devices


func _process(fixed):

	_multiplayer_setup()
	get_unjoined_devices()
	playersPlaying = Global.playersPlaying
	
	

#Start button logic, can create safegaurd for everyone to say ready first
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game(dev_area).tscn")
	


#Essentially takes all the devices and the moment someone hits A, or enter will add them as a player, assuming the device hasnt already been used
func _multiplayer_setup():
	for i in get_unjoined_devices():
		if MultiplayerInput.is_action_just_pressed(i, "jump"):
			if !devicesin.has(i):
				devicesin.append(i)
				playerjoin(i)
		

#This is saying hey, if the player size isnt 4, create a player, add it to the people playing, give it this value and placement and add it visually to the screen
func playerjoin(device):
	if playersPlaying.size() !=4 :
		var player = PLAYER_SELECT.instantiate()
		playersPlaying.append(player)
		for players in playersPlaying:
			player.playerNumber = playersPlaying.size()
			player.device = device
			player.characterChoice = 0
			player_containers.add_child(player)
			print(Global.playersPlaying)
