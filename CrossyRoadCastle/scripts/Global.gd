extends Node

# Setting up foundation for vairables that will need to be accessed
# Character Selection Done via a sheet, frame # will determine character
#Frame # will always be the main way of determining whats what

var isPlayer1active
var isPlayer2active
var isPlayer3active
var isPlayer4active

# For each of our levels can program to check the status of these booleans which will be set once play is hit from the main menu

var player1Choice: int
var player2Choice: int
var player3Choice: int
var player4Choice: int

# Everything here needs to be saved in Json

var goldCoin: int
var purpleCoin: int

enum{JavidTower, XiaoweiTower,ValentinaTower} # Javid = 0, Xiaowei = 1, Valentina = 2
var currentTower: int


#Booleans to save when characters are unlocked will flesh out more later

var isBonusCharacterUnlocked1
var isBonusCharacterUnlocked2



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
