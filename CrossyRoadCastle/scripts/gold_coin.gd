extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var coin_sound: AudioStreamPlayer2D = $CoinSound

var travel_dest
var speed = 500
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
	coin_sound.play()

func _deposit_coin():
	collision_shape_2d.disabled = true
	deposit = true
	coin_sound.play()



func _set_destination_position():
	travel_dest = get_parent().global_position
	
	
func _process(delta):
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
