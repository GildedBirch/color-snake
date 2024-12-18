extends Node2D
class_name Wall

var color: Color:
	set(color_in):
		color = color_in
		%ColorRect.color = color

var tile_position: Vector2i = Vector2i(0,0)

@export var random_color: bool = false

func _ready() -> void:
	color = Color.BLACK
	tile_position = Vector2i(int(position.x)/16, int(position.y)/16)
