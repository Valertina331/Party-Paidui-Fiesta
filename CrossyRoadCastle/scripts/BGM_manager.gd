extends Node

@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

var current_track := ""
var music_started := false

func _ready():
	add_child(music_player)
	music_player.bus = "Music"
	music_player.autoplay = false
	music_player.volume_db = -15

func play_music(track_path: String):
	# the music won't restart
	if music_started and current_track == track_path:
		return

	# change to new music
	if music_player.playing:
		music_player.stop()

	music_player.stream = load(track_path)
	music_player.play()
	music_started = true
	current_track = track_path
	print("Now playing:", track_path)

func stop_music():
	if music_player.playing:
		music_player.stop()
	music_started = false
	current_track = ""
