extends AudioStreamPlayer

const javid_levelmusic = preload("res://assets/Sound FX/Chamomile Tea.mp3")
const valentina_levelmusic = preload("res://assets/Sound FX/EasterTower.mp3")
const xiaowei_levelmusic = preload("res://assets/Sound FX/Alf Clausen - The Land of Chocolate (1991)_ Extended.mp3")
const main_menu_level_music = preload("res://assets/Sound FX/GEE LEE - WOW.mp3")

var music
var trackchoice

func _play_music(music: AudioStream, volume = -15):
	if stream == music:
		return
		
	stream = music
	#volume_db = volume
	play()

func play_music_level():
	_play_music(musicchoice(trackchoice))
	

func musicchoice(val):
	match val:
		-1:
			music = main_menu_level_music
			return music
		0:
			music = javid_levelmusic
			return music
		1:
			music = valentina_levelmusic
			return music
		2: 
			music = xiaowei_levelmusic
			return music
