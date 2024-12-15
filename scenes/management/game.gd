extends Node

const SNAKE_PART: PackedScene = preload("res://scenes/snake/snake_part.tscn")

enum {UP=1, DOWN=-1, LEFT=2, RIGHT=-2}
const DIR: Dictionary = {
	UP : Vector2i.UP,
	DOWN : Vector2i.DOWN,
	LEFT : Vector2i.LEFT,
	RIGHT : Vector2i.RIGHT
}

var input_direction: int = LEFT
var prev_dir: int = LEFT

@export var tile_size: int = 16
@export var map_size: Vector2i = Vector2i(20, 15)

func _ready() -> void:
	initialize_snake(3)
	print(map_size)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_up"):
		input_direction = UP
	if Input.is_action_just_pressed("ui_down"):
		input_direction = DOWN
	if Input.is_action_just_pressed("ui_left"):
		input_direction = LEFT
	if Input.is_action_just_pressed("ui_right"):
		input_direction = RIGHT

func initialize_snake(length: int) -> void:
	for i in range(length):
		var snake_part: SnakePart = SNAKE_PART.instantiate()
		%Snake.add_child(snake_part)
		snake_part.tile_position = Vector2i(floori(map_size.x/2) + i, floori(map_size.y/2))
		snake_part.position = Vector2i(
			floori(map_size.x/2)*tile_size + i*tile_size,
			floori(map_size.y/2)*tile_size
			)

func move(dir: int):
	if dir == -prev_dir: dir = prev_dir
	prev_dir = dir

func _on_game_tick_timer_timeout() -> void:
	move(input_direction)
