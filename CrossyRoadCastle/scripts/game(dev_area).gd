extends Node2D

var playersPlaying = []

const player = preload("res://scenes/player.tscn")

var currentYCoins : int
var currentPCoins : int
var floorsClimbed : int
var currentHearts : int

#Will put on export in inspector string can be modified
var tower_to_call = "res://javidtowerlevels/"
var typePrefix = ".tscn"

var totalplayers : int
var alldead = false
var levelpass = false
var startNextTimer = false

@onready var load_next_timer: Timer = $LoadNextTimer

#These have to be set in the inspect, make the heart on the right the first element
@export var spawnlocations: Array[Marker2D] = []
@export var hearticons: Array[Control] = []

#How players are instantiated onto the scene
@onready var game_dev_area_: Node2D = $"."


@onready var heart_containers: GridContainer = $LevelUI/HeartContainer
@onready var yellow_coin_amount: Label = $LevelUI/CoinLabels/YellowCoinAmount
@onready var purple_coin_amount: Label = $LevelUI/CoinLabels/PurpleCoinAmount
@onready var floortext: Label = $LevelUI/FloorLevel/Floortext


#Gets players from Global and increments floor level by one
#Grabs the door from Doortoadvance and connects to its signal
func _ready():
	_getplayers()
	Global.add_to_floor_climbed(1)
	var next_level_door = $DoorToAdvance/Door
	next_level_door.connect("levelpassed", Callable(self, "_on_level_passed"))
	
	
	
	
func _process(delta):
	_get_current_players()
	_getlabelinfo()
	
	#All dead triggered by update/process, remove heart is not flipped by anything else other than this call so it wont repeat
	if alldead == true:
		#there shouldn't be the situation of alldead == true and levelpass == true,
		#but I'll leave Javid's code here in case it caused bugs. --Valentina
		if levelpass == true:
			get_tree().change_scene_to_file(tower_to_call+str(Global.get_levels_climbed()+1)+typePrefix)
	
		Global.change_health(-1)
		_getplayers()
		alldead = false
		
		
	if alldead == false && levelpass == true && startNextTimer == false:
		load_next_timer.start(3)
		startNextTimer = true


#Takes the dictionary defined in Global from the main menu and uses it to program instances of players
func _getplayers():
		for players in Global.playersPlaying:
			var levelplayer = player.instantiate()
			var playerdata = Global.get_entry(str(players))
			levelplayer.device = playerdata.get("device")
			levelplayer.characterChoice = playerdata.get("characterChoice")
			levelplayer.playerNumber = playerdata.get("playerNumber")
			levelplayer.position = spawnlocations[levelplayer.playerNumber].global_position
			game_dev_area_.add_child(levelplayer)
		
		

func _getlabelinfo():
	#Each of these uses a method to properly overwrite local integers with the global integer
	currentYCoins = Global.get_current_yellow_coins()
	currentPCoins = Global.get_current_purple_coins()
	floorsClimbed = Global.get_levels_climbed()
	currentHearts = Global.get_current_health()
	
	yellow_coin_amount.text = str(currentYCoins)
	purple_coin_amount.text = str(currentPCoins)
	floortext.text = str(floorsClimbed)
	
	#Method I developed for my last game should not need to be touched, essentially if the amount of hearts is equal
	# to the current health stay red, if not turn grey
  #JavidsBranch
	if currentHearts != 0:
		hearticons[currentHearts-1]._full_heart()
		hearticons[0]._full_heart()
		for i in hearticons:
			if hearticons.size() == currentHearts:
				i._full_heart()
			if hearticons.size() > currentHearts:
				hearticons[currentHearts]._lost_heart()
	else:
		hearticons[0]._lost_heart()

	#Valentina's version (not sure if merging it directly will cause errors or not)
	#for i in range(hearticons.size()):
	#	if i < currentHearts:
	#		hearticons[i]._full_heart()
	#	else:
	#		hearticons[i]._lost_heart()
	#print("Updated hearts: ", currentHearts)


#Gets all the current players, only once everyones dead does it remove the heart
func _get_current_players():
	var totalplayers = get_tree().get_nodes_in_group("Player").size()
	if totalplayers == 0:
			alldead = true


#Will add code here to start timer, if all players arent destroyed advance to next stage
func _on_level_passed():
	levelpass = true
	

#Will replace with swirling animation like in real game
func _on_load_next_timer_timeout():
	var totalplayers = get_tree().get_nodes_in_group("Player")
	for players in totalplayers:
			players.queue_free()

#restart the level when all players are dead
#func restart_level():
	#removeheart = false
	#get_tree().reload_current_scene()
