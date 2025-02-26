extends Node2D

var playersPlaying = []
const player = preload("res://scenes/player.tscn")

@export var spawnlocations: Array[Marker2D] = []
@onready var game_dev_area_: Node2D = $"."

# Called when the node enters the scene tree for the first time.


func _ready():
	_getplayers()
	

func _getplayers():
		for players in Global.playersPlaying:
			var levelplayer = player.instantiate()
			var playerdata = Global.get_entry(str(players))
			levelplayer.device = playerdata.get("device")
			levelplayer.characterChoice = playerdata.get("characterChoice")
			levelplayer.playerNumber = playerdata.get("playerNumber")
			levelplayer.position = spawnlocations[levelplayer.playerNumber].position
			game_dev_area_.add_child(levelplayer)
			
