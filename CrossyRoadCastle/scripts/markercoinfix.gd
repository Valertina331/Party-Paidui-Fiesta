extends Marker2D


@export var adjust : Vector2
@onready var camera: Camera2D = $"../../Camera2D"




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = camera.global_position + adjust
