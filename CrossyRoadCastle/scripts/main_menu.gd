extends Control

#I know this is super repetitive but it kept getting a bug I couldnt figure out how to solve

var currentp1 = 0
var currentp2 = 0
var currentp3 = 0
var currentp4 = 0

var maxvalue = 2

var player2active
var player3active
var player4active

var device: int

@onready var sprite1: Sprite2D = $Player1/Sprite
@onready var sprite2: Sprite2D = $Player2/Sprite
@onready var sprite3: Sprite2D = $Player3/Sprite
@onready var sprite4: Sprite2D = $Player4/Sprite



func get_joined_devices():
	var devices = Input.get_connected_joypads()
	devices.append(-1)
	
	return devices

func _process(fixed):
	_whos_playing()
	_multiplayer_setup()
	get_joined_devices()
#Replace min max values once character sheet is more fleshed out, replace with variable

func update_sprite1(val):
	currentp1 += val
	currentp1 = min(currentp1, maxvalue)
	currentp1 = max(0, currentp1)
	sprite1.frame = currentp1

func update_sprite2(val):
	currentp2 += val
	currentp2 = min(currentp2, 2)
	currentp2 = max(0, currentp2)
	sprite2.frame = currentp2

func update_sprite3(val):
	currentp3 += val
	currentp3 = min(currentp3, 2)
	currentp3 = max(0, currentp3)
	sprite3.frame = currentp3

func update_sprite4(val):
	currentp4 += val
	currentp4 = min(currentp4, 2)
	currentp4 = max(0, currentp4)
	sprite4.frame = currentp4

# Probably a better way but I am lazy, buttons change corresponding sprites character

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game(dev_area).tscn")


func _whos_playing():

	if $Player1.visible == true:
		Global.isPlayer1active = true
		Global.player1Choice = currentp1
		Global.player1device = -1;
	
	if $Player2.visible == true:
		Global.isPlayer2active = true
		Global.player2Choice = currentp2
		Global.player2device = 0;
		$NotJoined2.visible = false
	else:
		Global.isPlayer2active = false
		Global.player2Choice = 0
		$NotJoined2.visible = true
		
	if $Player3.visible == true:
		Global.isPlayer3active = true
		Global.player3Choice = currentp3
		Global.player3device = 1
		$NotJoined3.visible = false
	else:
		Global.isPlayer3active = false
		Global.player3Choice = 0
		$NotJoined3.visible = true
	
	if $Player4.visible == true:
		Global.isPlayer4active = true
		Global.player4Choice = currentp4
		Global.player4device = 2
		$NotJoined4.visible = false
	else:
		Global.isPlayer4active = false
		Global.player4Choice = 0
		$NotJoined4.visible = true
		
func _multiplayer_setup():
	for i in get_joined_devices():
		if MultiplayerInput.is_action_just_pressed(i, "jump"):
			match i:
				0:
					player2active = !player2active
				1: 
					player3active = !player3active
				2:
					player4active = !player4active
		if MultiplayerInput.is_action_just_pressed(i,"move_left"):
			match i:
				-1: 
					_on_p_1_left_arrow_pressed()
				0: 
					_on_p_2_left_arrow_pressed()
				1:
					_on_p_3_left_arrow_pressed()
				2:
					_on_p_4_left_arrow_pressed()
		if MultiplayerInput.is_action_just_pressed(i,"move_right"):
			match i:
				-1: 
					_on_p_1_right_arrow_pressed()
				0: 
					_on_p_2_right_arrow_pressed()
				1:
					_on_p_3_right_arrow_pressed()
				2:
					_on_p_4_right_arrow_pressed()
		if MultiplayerInput.is_action_just_pressed(i,"start"):
			_on_play_button_pressed()
		
		
	if player2active:
		$Player2.visible = true
	else:
		$Player2.visible = false
		
	if player3active:
		$Player3.visible = true
	else:
		$Player3.visible = false
		
	if player4active:
		$Player4.visible = true
	else:
		$Player4.visible = false



func _on_p_1_right_arrow_pressed():
	if currentp1 != maxvalue:
		update_sprite1(+1)
	else:
		currentp1 = 0;
		sprite1.frame = currentp1


func _on_p_1_left_arrow_pressed():
	if currentp1 != 0:
		update_sprite1(-1)
	else:
		currentp1 = maxvalue
		sprite1.frame = currentp1
		
func _on_p_2_right_arrow_pressed():
	if currentp2 != maxvalue:
		update_sprite2(+1)
	else:
		currentp2 = 0;
		sprite2.frame = currentp2

func _on_p_2_left_arrow_pressed():
	if currentp2 != 0:
		update_sprite2(-1)
	else:
		currentp2 = maxvalue
		sprite2.frame = currentp2


func _on_p_3_right_arrow_pressed():
	if currentp3 != maxvalue:
		update_sprite3(+1)
	else:
		currentp3 = 0;
		sprite3.frame = currentp3


func _on_p_3_left_arrow_pressed():
	if currentp3 != 0:
		update_sprite3(-1)
	else:
		currentp3 = maxvalue
		sprite3.frame = currentp3


func _on_p_4_right_arrow_pressed():
	if currentp4 != maxvalue:
		update_sprite4(+1)
	else:
		currentp4 = 0;
		sprite4.frame = currentp4

func _on_p_4_left_arrow_pressed():
	if currentp4 != 0:
		update_sprite4(-1)
	else:
		currentp4 = maxvalue
		sprite4.frame = currentp4	
