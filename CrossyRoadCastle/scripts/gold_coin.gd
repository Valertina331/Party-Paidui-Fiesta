extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var coin_sound: AudioStreamPlayer2D = $CoinSound
@onready var timer: Timer = $Timer


var travel_dest
var speed = 1000
var travel = false
var deposit = false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		monitoring = false
		_collect_coin()
		
func _collect_coin():
	call_deferred("_set_destination_position")
	collision_shape_2d.disabled = true
	travel = true
	timer.wait_time = 0.75
	timer.start()
	coin_sound.play()

func _deposit_coin():
	collision_shape_2d.disabled = true
	deposit = true
	



func _set_destination_position():
	if deposit == false:
		travel_dest = get_parent().get_child(0).global_position
	if deposit == true:
		get_parent().global_position
	
func _process(delta):
	_set_destination_position()
	
	if travel == true:
		var direction = travel_dest - global_position
		direction = direction.normalized()
		global_position += direction * speed * delta
		if global_position.distance_to(travel_dest) < 5:
			global_position = travel_dest
			Global.change_yellow_coins(+1)
			queue_free()
	if deposit == true:
		var direction = travel_dest - global_position
		direction = direction.normalized()
		global_position += direction * speed * delta
		if global_position.distance_to(travel_dest) < 5:
			Global.change_coins_deducted(+1)
			global_position = travel_dest
			queue_free()
# Trying to fix a glitch
func _on_timer_timeout():
	Global.change_yellow_coins(+1)
	global_position = travel_dest
	queue_free()
