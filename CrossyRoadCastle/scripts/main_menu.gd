extends Control


#I know this is super repetitive but it kept getting a bug I couldnt figure out how to solve
const MAX_CHARACTER_INDEX = 2 #max number of characters


var player_choices = {
	"Player1": 0,
	"Player2": 0,
	"Player3": 0,
	"Player4": 0
}

@onready var players = {
	"Player1": {
		"sprite": $Player1/Sprite,
		"left_button": $Player1/P1LeftArrow,
		"right_button": $Player1/P1RightArrow
	},
	"Player2": {
		"sprite": $Player2/Sprite,
		"left_button": $Player2/P2LeftArrow,
		"right_button": $Player2/P2RightArrow
	},
	"Player3": {
		"sprite": $Player3/Sprite,
		"left_button": $Player3/P3LeftArrow,
		"right_button": $Player3/P3RightArrow
	},
	"Player4": {
		"sprite": $Player4/Sprite,
		"left_button": $Player4/P4LeftArrow,
		"right_button": $Player4/P4RightArrow
	}
}

@onready var not_joined_labels = {
	"Player2": $NotJoined2,
	"Player3": $NotJoined3,
	"Player4": $NotJoined4
}
@onready var play_button = $PlayButton

var active_players = {
	"Player1": true,
	"Player2": false,
	"Player3": false,
	"Player4": false
}
func _ready():
	for player in players.keys():
		players[player]["left_button"].pressed.connect(func(): change_character(player, -1))
		players[player]["right_button"].pressed.connect(func(): change_character(player, 1))
	play_button.pressed.connect(_on_play_pressed)
	update_ui()
	
func change_character(player, direction):
	player_choices[player] = (player_choices[player] + direction) % (MAX_CHARACTER_INDEX + 1)
	update_ui()
func update_ui():
	for player in players.keys():
		players[player]["sprite"].frame = player_choices[player]
		not_joined_labels[player].visible = not active_players[player]
		players[player]["sprite"].visible = active_players[player]
		
func _on_play_pressed():
	print("final character:", player_choices)
	get_tree().change_scene_to_file("res://scenes/game(dev_area).tscn")
	
func toggle_player_active(player):
	active_players[player] = !active_players[player]
	update_ui()

func _input(event):
	if event.is_action_pressed("Testdebug2"):
		toggle_player_active("Player2")
	if event.is_action_pressed("Testdebug3"):
		toggle_player_active("Player3")
	if event.is_action_pressed("Testdebug4"):
		toggle_player_active("Player4")
