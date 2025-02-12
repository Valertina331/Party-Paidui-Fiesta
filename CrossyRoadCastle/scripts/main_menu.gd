extends Control


#I know this is super repetitive but it kept getting a bug I couldnt figure out how to solve

var currentp1 = 0
var currentp2 = 0
var currentp3 = 0
var currentp4 = 0


@onready var sprite1: Sprite2D = $Player1/Sprite
@onready var sprite2: Sprite2D = $Player2/Sprite
@onready var sprite3: Sprite2D = $Player3/Sprite
@onready var sprite4: Sprite2D = $Player4/Sprite


#Replace min max values once character sheet is more fleshed out, replace with variable

func update_sprite1(val):
	currentp1 += val
	currentp1 = min(currentp1, 2)
	currentp1 = max(0, currentp1)
	sprite1.frame = currentp1

func update_sprite2(val):
	currentp2 += val
	currentp2 = min(currentp2, 2)
	currentp2 = max(0, currentp2)
	sprite2.frame = currentp2

func update_sprite3(val):
	currentp3 += val
	currentp3 = min(currentp3, 2)
	currentp3 = max(0, currentp3)
	sprite3.frame = currentp3

func update_sprite4(val):
	currentp4 += val
	currentp4 = min(currentp4, 2)
	currentp4 = max(0, currentp4)
	sprite4.frame = currentp4

# Probably a better way but I am lazy, buttons change corresponding sprites character

func _on_p_1_right_arrow_pressed():
	update_sprite1(+1)


func _on_p_1_left_arrow_pressed():
	update_sprite1(-1)

func _on_p_2_right_arrow_pressed():
	update_sprite2(+1)


func _on_p_2_left_arrow_pressed():
	update_sprite2(-1)


func _on_p_3_right_arrow_pressed():
	update_sprite3(+1)


func _on_p_3_left_arrow_pressed():
	update_sprite3(-1)


func _on_p_4_right_arrow_pressed():
	update_sprite4(+1)


func _on_p_4_left_arrow_pressed():
	update_sprite4(-1)
