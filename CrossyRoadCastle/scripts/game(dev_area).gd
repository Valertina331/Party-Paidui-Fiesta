extends Node2D

var playersPlaying = []

const player = preload("res://scenes/player.tscn")


var currentYCoins : int
var currentPCoins : int
var floorsClimbed : int
var currentHearts : int

#Will put on export in inspector string can be modified
var tower_to_call = Global.tower_to_call
var typePrefix = ".tscn"

var totalplayers : int
var alldead = false
var levelpass = false
var startNextTimer = false

@onready var load_next_timer: Timer = $LoadNextTimer


#camera follow
@onready var camera = $Camera2D
@onready var camera_bounds = $CameraBounds
@onready var camera_shape = $CameraBounds/CollisionShape2D
var left_camera_limit
var right_camera_limit
var top_camera_limit
var bottom_camera_limit
var base_zoom = 1.0
var min_zoom = 0.5
var last_distance = 0 

#These have to be set in the inspect, make the heart on the right the first element
@export var spawnlocations: Array[Marker2D] = []
@export var hearticons: Array[Control] = []

#How players are instantiated onto the scene
@onready var game_dev_area_: Node2D = $"."


@onready var heart_containers: GridContainer = $UILayer/LevelUI/HeartContainer
@onready var yellow_coin_amount: Label = $UILayer/LevelUI/CoinLabels/YellowCoinAmount
@onready var purple_coin_amount: Label = $UILayer/LevelUI/CoinLabels/PurpleCoinAmount
@onready var floortext: Label = $UILayer/LevelUI/FloorLevel/Floortext
@onready var pause_menu: Control = $UILayer/PauseMenu

@export var debug : bool



#Gets players from Global and increments floor level by one
#Grabs the door from Doortoadvance and connects to its signal
func _ready():
	if debug == false:
		_getplayers()
		
	if debug == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Global.debugtest()
		Global.change_yellow_coins(100)
		_getplayers()
		_getlabelinfo()
	var next_level_door = $DoorToAdvance/Door
	next_level_door.connect("levelpassed", Callable(self, "_on_level_passed"))
	
	var initial_pos = camera.position
	print("camera: ", initial_pos)
	var shape = camera_bounds.get_node("CollisionShape2D").shape
	var half_size = shape.extents
	
	#calculate the bounds
	left_camera_limit = camera_shape.position.x - half_size.x + initial_pos.x
	right_camera_limit = camera_shape.position.x + half_size.x - initial_pos.x
	top_camera_limit = camera_shape.position.y - half_size.y + initial_pos.y
	bottom_camera_limit = camera_shape.position.y + half_size.y - initial_pos.y
	print("Camera Limits: ", left_camera_limit,"+", right_camera_limit,"+", top_camera_limit,"+", bottom_camera_limit)
	camera.zoom = Vector2(base_zoom, base_zoom)
	GlobalAudioStreamPlayer.trackchoice = Global.towerintforjson
	GlobalAudioStreamPlayer.play_music_level()
	
func _process(delta):
	_get_current_players()
	_getlabelinfo()
	enemy_play()
	
	#All dead triggered by update/process, remove heart is not flipped by anything else other than this call so it wont repeat
	if alldead == true && levelpass == false:
		Global.change_health(-1)
		get_tree().reload_current_scene()
		
		
	if alldead == true and levelpass == true:
		Global.add_to_floor_climbed(1)
		get_tree().change_scene_to_file(tower_to_call+str(Global.get_levels_climbed()+1)+typePrefix)
		
	if alldead == false && levelpass == true && startNextTimer == false:
		load_next_timer.start(3)
		startNextTimer = true
		
	#camera follow
	if not is_inside_tree():
		return
	
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() == 0:
		return
	
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF
	
	for player in players:
		var pos = player.global_position
		min_x = min(min_x, pos.x)
		max_x = max(max_x, pos.x)
		min_y = min(min_y, pos.y)
		max_y = max(max_y, pos.y)
	var center_x = (min_x + max_x) / 2
	var center_y = (min_y + max_y) / 2
		
	var target_position = Vector2(center_x, center_y)
	target_position.x = clamp(target_position.x, left_camera_limit, right_camera_limit)
	target_position.y = clamp(target_position.y, top_camera_limit, bottom_camera_limit)
	
	camera.position = camera.position.lerp(target_position, 0.05)
	
	#zoom in or out
	var screen_size = get_viewport_rect().size
	var visible_width = screen_size.x / camera.zoom.x - 100
	var visible_height = screen_size.y / camera.zoom.y - 100
	
	var player_distance_x = max_x - min_x
	var player_distance_y = max_y - min_y
	var max_distance = max(player_distance_x, player_distance_y)
	
	var all_players_inside_x = (max_x - min_x) <= visible_width
	var all_players_inside_y = (max_y - min_y) <= visible_height
	
	var is_decreasing = max_distance < last_distance
	last_distance = max_distance
	var target_zoom = clamp(1.0 - (max_distance / 1000.0), min_zoom, base_zoom)

	if !(all_players_inside_x and all_players_inside_y):
		camera.zoom = camera.zoom.lerp(Vector2(target_zoom, target_zoom), 0.05)
	elif is_decreasing:
		var zoom_to_reach = camera.zoom.x + 0.1
		zoom_to_reach = clamp(zoom_to_reach, target_zoom, base_zoom)
		camera.zoom = camera.zoom.lerp(Vector2(zoom_to_reach, zoom_to_reach), 0.05)

#Takes the dictionary defined in Global from the main menu and uses it to program instances of players
func _getplayers():
		for players in Global.playersPlaying:
			var levelplayer = player.instantiate()
			var playerdata = Global.get_entry(str(players))
			levelplayer.device = playerdata.get("device")
			levelplayer.characterChoice = playerdata.get("characterChoice")
			levelplayer.playerNumber = playerdata.get("playerNumber")
			levelplayer.position = spawnlocations[levelplayer.playerNumber].global_position
			levelplayer.travel_dest = $DoorToAdvance/Door.global_position
			game_dev_area_.add_child(levelplayer)
			
			var pause_menu = get_tree().get_first_node_in_group("PauseMenu")
			if pause_menu:
				print("Pausemenu found")
				levelplayer.connect("pause_requested", Callable(pause_menu, "_on_pause_requested"))
			
			
			if Global.playersPlaying.size() > 1:
				levelplayer.multiplayerplaythrough = true
				levelplayer._display_setup()
		

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
			players._too_slow()
			
func enemy_play():
	var enemyAnimators = get_tree().get_nodes_in_group("EBodyAnim")
	for animations in enemyAnimators:
		animations.play("Movement")
