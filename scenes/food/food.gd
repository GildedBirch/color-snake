extends Node2D
class_name Food

var color: Color:
	set(color_in):
		color = color_in
		%ColorRect.color = color

var tile_position: Vector2i = Vector2i(0,0)
