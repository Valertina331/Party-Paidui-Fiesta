extends Node2D


func _ready():
	_the_setup()
		


func _the_setup():
	if Global.isPlayer1active == true:
		$Player1.visible = true
		$Player1.playerChoice = Global.player1Choice
	
	if Global.isPlayer2active == true:
		$Player2.visible = true
		$Player2.playerChoice = Global.player2Choice
		
	if Global.isPlayer3active == true:
		$Player3.visible = true
		$Player3.playerChoice = Global.player3Choice
		
	if Global.isPlayer4active == true:
		$Player4.visible = true
		$Player4.playerChoice = Global.player4Choice
