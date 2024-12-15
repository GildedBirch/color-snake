extends ColorNode2D
class_name SnakePart

var tile_position: Vector2i = Vector2i(0,0)

func _ready() -> void:
	%ColorRect.color = Color(randf(), randf(), randf())
