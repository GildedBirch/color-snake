extends Node2D
class_name SnakePart

var color: Color:
	set(color_in):
		color = color_in
		%SnakeSprite.self_modulate = color

enum {HEAD, HEAD_CURVE, BODY, BODY_CURVE, TAIL}
var part: int = BODY:
	set(part_in):
		part = part_in
		_set_part_model(parts[part])

var parts: Dictionary = {
	HEAD: Rect2i(0, 0, 16, 16),
	HEAD_CURVE: Rect2i(16, 0, 16, 16),
	BODY: Rect2i(0, 16, 16, 16),
	BODY_CURVE: Rect2i(16, 16, 16, 16),
	TAIL: Rect2i(0, 32, 16, 16)
}
var tile_position: Vector2i = Vector2i(0,0)

func _set_part_model(new_part: Rect2i):
	%SnakeSprite.texture.region = new_part

func set_rotation_and_part(prev_pos: Vector2i, ahead_pos: Vector2i):
	match part:
		HEAD:
			set_head_rotation(prev_pos)
		TAIL:
			set_tail_rotation(ahead_pos)
		_:
			set_body_rotation(prev_pos, ahead_pos)

func set_head_rotation(prev_pos: Vector2i):
	match prev_pos-tile_position:
		Vector2i.DOWN:
			%SnakeSprite.rotation = deg_to_rad(0)
		Vector2i.UP:
			%SnakeSprite.rotation = deg_to_rad(180)
		Vector2i.RIGHT:
			%SnakeSprite.rotation = deg_to_rad(-90)
		Vector2i.LEFT:
			%SnakeSprite.rotation = deg_to_rad(90)

func set_tail_rotation(ahead_pos: Vector2i):
	match ahead_pos-tile_position:
		Vector2i.UP:
			%SnakeSprite.rotation = deg_to_rad(0)
		Vector2i.DOWN:
			%SnakeSprite.rotation = deg_to_rad(180)
		Vector2i.LEFT:
			%SnakeSprite.rotation = deg_to_rad(-90)
		Vector2i.RIGHT:
			%SnakeSprite.rotation = deg_to_rad(90)

func set_body_rotation(prev_pos: Vector2i, ahead_pos: Vector2i):
	var new_part = BODY
	match [prev_pos-tile_position,ahead_pos-tile_position]:
		[Vector2i.DOWN,Vector2i.UP]:
			%SnakeSprite.rotation = deg_to_rad(0)
		[Vector2i.UP,Vector2i.DOWN]:
			%SnakeSprite.rotation = deg_to_rad(180)
		[Vector2i.RIGHT,Vector2i.LEFT]:
			%SnakeSprite.rotation = deg_to_rad(90)
		[Vector2i.LEFT,Vector2i.RIGHT]:
			%SnakeSprite.rotation = deg_to_rad(-90)
		#Angled
		[Vector2i.LEFT,Vector2i.UP], [Vector2i.UP,Vector2i.LEFT]:
			new_part = BODY_CURVE
			%SnakeSprite.rotation = deg_to_rad(180)
		[Vector2i.RIGHT,Vector2i.DOWN], [Vector2i.DOWN,Vector2i.RIGHT]:
			new_part = BODY_CURVE
			%SnakeSprite.rotation = deg_to_rad(0)
		[Vector2i.DOWN,Vector2i.LEFT], [Vector2i.LEFT,Vector2i.DOWN]:
			new_part = BODY_CURVE
			%SnakeSprite.rotation = deg_to_rad(90)
		[Vector2i.UP,Vector2i.RIGHT], [Vector2i.RIGHT,Vector2i.UP]:
			new_part = BODY_CURVE
			%SnakeSprite.rotation = deg_to_rad(-90)
	#
	match new_part:
		BODY:
			part = BODY
		BODY_CURVE:
			part = BODY_CURVE
