extends Node2D

var playersPlaying = []
const player = preload("res://scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _process(delta):
	pass
	
func _ready():
	playersPlaying = Global.playersPlaying
	
	for players in playersPlaying:
		var levelplayer = player.instantiate()
		levelplayer.device = playersPlaying[players].device
		levelplayer.characterChoice = playersPlaying[players].characterChoice
		levelplayer.playerNumber = playersPlaying[players].playerNumber
