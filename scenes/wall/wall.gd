extends Node2D
class_name Wall

var color: Color:
	set(color_in):
		color = color_in
		%WallSprite.self_modulate = color

var tile_position: Vector2i = Vector2i(0,0)

var wall_types: Dictionary = {
	WALL_TYPE.PIPE_ALONE: Rect2i(0,0,16,16),
	WALL_TYPE.PIPE_STRAIGHT: Rect2i(16,0,16,16),
	WALL_TYPE.PIPE_END: Rect2i(32,0,16,16),
	WALL_TYPE.PIPE_CORNER: Rect2i(0,16,16,16),
	WALL_TYPE.PIPE_T: Rect2i(16,16,16,16),
	WALL_TYPE.PIPE_FOUR: Rect2i(64,0,16,16),
	WALL_TYPE.STRAIGHT: Rect2i(48,0,16,16),
	WALL_TYPE.T_JUNCTION: Rect2i(32,16,16,16),
	WALL_TYPE.CORNER: Rect2i(48,16,16,16)
}

enum WALL_TYPE {
	PIPE_ALONE, PIPE_STRAIGHT, PIPE_END, PIPE_CORNER, PIPE_T, PIPE_FOUR,
	STRAIGHT, T_JUNCTION, CORNER
}
@export var wall_type: WALL_TYPE = WALL_TYPE.PIPE_ALONE
@export var wall_rotation: int = 0
@export var random_color: bool = false

func _ready() -> void:
	%WallSprite.texture.region = wall_types[wall_type]
	%WallSprite.rotation = deg_to_rad(wall_rotation)
	color = Color.DIM_GRAY
	tile_position = Vector2i(int(position.x)/16, int(position.y)/16)
