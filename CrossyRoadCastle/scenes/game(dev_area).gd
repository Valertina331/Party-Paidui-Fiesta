extends Node2D

@onready var player: player = $Player
@onready var player_2: player = $Player2

# Called when the node enters the scene tree for the first time.
func _process(delta):
	pass
	
func _ready():
	_the_setup()
		


func _the_setup():
	if Global.isPlayer1active == true:
		$Player.visible = true
		$Player.playerChoice = Global.player1Choice

	if Global.isPlayer2active == true:
		$Player2.visible = true
		$Player2.playerChoice = Global.player2Choice
		
	if Global.isPlayer3active == true:
		$Player3.visible = true
		$Player3.playerChoice = Global.player3Choice
		
	if Global.isPlayer4active == true:
		$Player4.visible = true
		$Player4.playerChoice = Global.player4Choice
