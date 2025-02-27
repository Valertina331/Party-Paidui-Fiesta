extends CharacterBody2D

class_name player

const death_Speed = -100
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var device : int
var playerNumber: int
var characterChoice: int

var is_dead = false
var fall = false


@onready var death_pause: Timer = $DeathPause
@onready var dead_exclaim: TextureRect = $DeadExclaim
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var bounce_velocity := -300
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D



func _physics_process(delta):
	
	#For testing delete laTER
	#if MultiplayerInput.is_action_just_pressed(device,"cancel"):
		#is_dead = true
	
	
	
	if is_dead == false:
	
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Handle jump.
		if MultiplayerInput.is_action_just_pressed(device,"jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := MultiplayerInput.get_axis(device,"move_left", "move_right")
	
		if direction> 0:
			animated_sprite_2d.flip_h = false
		elif direction < 0:
			animated_sprite_2d.flip_h = true
	
		if direction == 0:
			animated_sprite_2d.play(str(characterChoice)+ "idle")
		else:
			animated_sprite_2d.play(str(characterChoice)+"walking")
	
	
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
		
	if is_dead == true && dead_exclaim.visible == false:
		dead()
		
	if fall == true:
		position.y -= death_Speed * delta
		dead_exclaim.visible = false
	
#bounce when step on enemies
func bounce():
	velocity.y = bounce_velocity
	move_and_slide()
	
#These two lead to the death process, removes instance of player
func dead():
	position = position
	dead_exclaim.visible = true
	collision_shape_2d.disabled = true
	death_pause.start()

func _on_death_pause_timeout():
	animation_player.play("death")
	fall = true
	
