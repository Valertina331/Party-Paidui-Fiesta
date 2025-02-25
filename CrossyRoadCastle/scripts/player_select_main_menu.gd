extends Control


@onready var player_frame_ext: TextureRect = $PlayerFrameExt
@onready var player_frame_int: TextureRect = $PlayerFrameInt
@onready var sprite: Sprite2D = $Sprite
@onready var player_num_label: Label = $PlayerNumLabel
@onready var maxvalue = Global.availableCharacters


var playerNumber : int
var characterChoice : int
var device: int


func _ready():
	characterChoice = 0
	match playerNumber:
		1:
			player_frame_ext.modulate = Color.RED
			player_frame_int.modulate = Color.INDIAN_RED
			player_num_label.text = "P1"
		2:
			player_frame_ext.modulate = Color.ROYAL_BLUE
			player_frame_int.modulate = Color.DEEP_SKY_BLUE
			player_num_label.text = "P2"
			
		3:
			player_frame_ext.modulate = Color.LIME_GREEN
			player_frame_int.modulate = Color.GREEN
			player_num_label.text = "P3"
			
		4:
			player_frame_ext.modulate = Color.ORANGE
			player_frame_int.modulate = Color.YELLOW
			player_num_label.text = "P4"
			


func _process(delta):
	
	choose_Character()
	
	
	
func update_sprite(val):
	characterChoice += val
	characterChoice = min(characterChoice, maxvalue)
	characterChoice = max(0, characterChoice)
	sprite.frame = characterChoice

func choose_Character():
	if MultiplayerInput.is_action_just_pressed(device, "move_left"):
		_on_left_arrow_pressed()
	if MultiplayerInput.is_action_just_pressed(device, "move_right"):
		_on_right_arrow_pressed()


func _on_right_arrow_pressed():
	if characterChoice != maxvalue:
		update_sprite(+1)
	else:
		characterChoice = 0
		sprite.frame = characterChoice

func _on_left_arrow_pressed():
	if characterChoice !=0:
		update_sprite(-1)
	else:
		characterChoice = maxvalue
		sprite.frame = characterChoice
