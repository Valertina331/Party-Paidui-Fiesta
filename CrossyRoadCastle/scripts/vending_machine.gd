extends Node2D


const coin = preload("res://scenes/gold_coin.tscn")
const heart = preload("res://scenes/collectible_heart.tscn")

var requiredAmount = 35
@onready var vending_machine_animated_sprite_2d: AnimatedSprite2D = $"Vencing Machine Holder/VendingMachineAnimatedSprite2D"
@onready var button_animated_sprite_2d: AnimatedSprite2D = $"Button Holder/ButtonArea2D/ButtonAnimatedSprite2D"
@onready var coin_slot: Marker2D = $"Vencing Machine Holder/CoinSlot"
@onready var heart_dispense: Marker2D = $"Vencing Machine Holder/HeartDispense"
@onready var animation_player: AnimationPlayer = $"Vencing Machine Holder/VendingMachineAnimatedSprite2D/AnimationPlayer"
@onready var stand_here: Marker2D = $StandHere

var buttonDown = false
var travel_dest
var speed : int

var coins_deducted = 0

var startpoint = Vector2(-573,-430)

func _on_button_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		if Global.get_current_yellow_coins() >= requiredAmount && Global.get_current_health() < 3:
			button_animated_sprite_2d.play("down")
			buttonDown = true
			body.global_position = stand_here.global_position
			Global.playerFreeze = true
			Global.reset_coins_deducted()
			_start_depositing_coins()
			

func _on_button_area_2d_body_exited(body):
	if body.is_in_group("Player"):
			button_animated_sprite_2d.play("up")
			buttonDown = false
			_refund_remaining_coins()

func _start_depositing_coins():
	var speed_increase = 5 # Speed increase per coin
	var base_speed = 100  # Starting speed
	
	for i in range(requiredAmount):
		if not buttonDown or Global.get_current_yellow_coins() <= 0:
			print("Stopping early: buttonDown =", buttonDown, "coins left =", Global.get_current_yellow_coins())
			break  # Stop if the player leaves or runs out of coins
		
		
		Global.change_yellow_coins(-1)
		# Instantiate the coin
		var coinstofly = coin.instantiate()
		get_parent().add_child(coinstofly)
		coinstofly.global_position = get_parent().global_position
		coinstofly.travel_dest = coin_slot.global_position
		get_parent().get_parent().camera.add_child(coinstofly)
		# Set the speed dynamically
		coinstofly.speed = base_speed + (i * speed_increase)
		# Call the coin's movement function (assuming _deposit_coin handles movement)
		coinstofly._deposit_coin()
		# Small delay for cascading effect
		await get_tree().create_timer(0.05).timeout

func _refund_remaining_coins():
	if Global.get_coins_deducted() > 0:
		Global.change_yellow_coins(Global.get_coins_deducted())
		coins_deducted = 0;
		
		
func _vend_a_heart():
	if buttonDown == true:
		if Global.get_coins_deducted() == requiredAmount:
			animation_player.play("renderheart")
			Global.reset_coins_deducted()
			buttonDown = false
			Global.playerFreeze = false

func hereyago():
	var heartwon = heart.instantiate()
	get_parent().add_child(heartwon)
	heartwon.global_position = heart_dispense.global_position
	get_parent().get_parent().camera.add_child(heartwon)
	


func _process(delta):
	_vend_a_heart()
