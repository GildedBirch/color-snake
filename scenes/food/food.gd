extends Node2D
class_name Food

var foods: Array[Rect2i] = [
	Rect2i(0, 0, 8, 8),
	Rect2i(8, 0, 8, 8),
	Rect2i(0, 8, 8, 8),
	Rect2i(8, 8, 8, 8),
]

var color: Color:
	set(color_in):
		color = color_in
		%FoodSprite.self_modulate = color
		%FoodSprite.texture.region = foods.pick_random()
		%FoodSprite.rotation = deg_to_rad([0, 90, 180, -90].pick_random())
		

var tile_position: Vector2i = Vector2i(0,0)
