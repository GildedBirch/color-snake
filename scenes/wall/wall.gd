extends Node2D
class_name Wall

var color: Color:
	set(color_in):
		color = color_in
		%ColorRect.color = color

var tile_position: Vector2i = Vector2i(0,0)

func _ready() -> void:
	%ColorRect.color = Color.DIM_GRAY
