extends Node2D

var playersPlaying = []
const player = preload("res://scenes/player.tscn")

@export var spawnlocations: Array[Marker2D] = []
@onready var game_dev_area_: Node2D = $"."

# Called when the node enters the scene tree for the first time.


func _ready():
	playersPlaying = _get_array()
	_getplayers()

func _get_array():
	return Global.playersPlaying

func _getplayers():
	for players in playersPlaying:
		var levelplayer = player.instantiate()
		levelplayer.device = playersPlaying[players].device
		game_dev_area_.add_child(levelplayer)
