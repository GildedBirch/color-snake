extends Node

signal died(score: int, snake_length: int)

const SNAKE_PART: PackedScene = preload("res://scenes/snake/snake_part.tscn")
const FOOD: PackedScene = preload("res://scenes/food/food.tscn")

const colors: Array[Color] = [
	Color.RED,
	Color.GREEN,
	Color.BLUE,
]

#Directions
enum {UP=1, DOWN=-1, LEFT=2, RIGHT=-2}
const DIR: Dictionary = {
	UP : Vector2i.UP,
	DOWN : Vector2i.DOWN,
	LEFT : Vector2i.LEFT,
	RIGHT : Vector2i.RIGHT
}
var input_direction: int = LEFT
var prev_dir: int = LEFT

#Scoring
var score: int = 0
var snake_length: int:
	get():
		return %Snake.get_children().size()

@export var tile_size: int = 16
@export var map_size: Vector2i = Vector2i(20, 15)

func _ready() -> void:
	died.connect(game_over)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_up"):
		input_direction = UP
	if Input.is_action_just_pressed("ui_down"):
		input_direction = DOWN
	if Input.is_action_just_pressed("ui_left"):
		input_direction = LEFT
	if Input.is_action_just_pressed("ui_right"):
		input_direction = RIGHT

func start_new_game():
	%Snake.get_children().all(func(snake_part): snake_part.queue_free(); return true)
	%Food.get_children().all(func(food): food.queue_free(); return true)
	score = 0
	input_direction = LEFT
	prev_dir = LEFT
	initialize_snake(3)
	%ScoreLabel.visible = true
	%ScoreLabel.text = "Score: %s  |  Length: %s" % [score, 3]
	%GameTickTimer.wait_time = 0.5
	%GameTickTimer.start()

func initialize_snake(length: int) -> void:
	var color = colors.pick_random()
	for i in range(length):
		var snake_part: SnakePart = SNAKE_PART.instantiate()
		%Snake.add_child(snake_part)
		snake_part.color = color
		snake_part.tile_position = Vector2i(floori(map_size.x/2) + i, floori(map_size.y/2))
		snake_part.position = Vector2i(
			floori(map_size.x/2)*tile_size + i*tile_size,
			floori(map_size.y/2)*tile_size
			)

func move(dir: int):
	if dir == -prev_dir: dir = prev_dir
	prev_dir = dir
	
	var prev_pos: Vector2i = %Snake.get_child(0).tile_position + DIR[dir]
	if eat(prev_pos):
		return
	if collide(prev_pos):
		died.emit(score, snake_length)
		return
	
	var prev_color: Color = %Snake.get_child(0).color
	
	for snake_part: SnakePart in %Snake.get_children():
		var new_pos: Vector2i = prev_pos
		prev_pos = snake_part.tile_position
		snake_part.tile_position = new_pos
		var new_color: Color = prev_color
		prev_color = snake_part.color
		snake_part.color = new_color
		snake_part.position = tile_to_world_pos(snake_part.tile_position)

func eat(prev_pos: Vector2i) -> bool:
	var food: Dictionary = {}
	for food_item: Food in %Food.get_children():
		food[food_item.tile_position] = food_item
	
	if food.has(prev_pos):
		var food_color = food[prev_pos].color
		food[prev_pos].queue_free()
		if food_color != %Snake.get_child(0).color:
			score += 2
		else:
			score += 1
		add_snake_part(prev_pos, food_color)
		%GameTickTimer.wait_time += 0.1
		return true
	return false

func collide(prev_pos: Vector2i) -> bool:
	var snake_parts: Dictionary = {}
	for snake_part: SnakePart in %Snake.get_children().slice(1):
		snake_parts[snake_part.tile_position] = snake_part

	if snake_parts.has(prev_pos):
		if snake_parts[prev_pos].color != %Snake.get_child(0).color:
			return true
	return false

func add_snake_part(pos: Vector2i, food_color: Color):
	var snake_part: SnakePart = SNAKE_PART.instantiate()
	%Snake.add_child(snake_part)
	snake_part.color = food_color
	snake_part.tile_position = pos
	snake_part.position = tile_to_world_pos(pos)
	%Snake.move_child(snake_part, 0)

func spawn_food():
	var pos: Vector2i = Vector2i(randi_range(1, map_size.x-2), randi_range(1, map_size.y-2))
	var food: Food = FOOD.instantiate()
	%Food.add_child(food)
	food.tile_position = pos
	food.position = tile_to_world_pos(pos)
	food.color = colors.pick_random()

func game_over(_score: int, _snake_length: int):
	%GameTickTimer.stop()
	%ScoreLabel.visible = false

func tile_to_world_pos(tile_position: Vector2i) -> Vector2i:
	return Vector2i(tile_position.x * tile_size, tile_position.y * tile_size)

func _on_game_tick_timer_timeout() -> void:
	move(input_direction)
	if randf() > 0.8:
		spawn_food()
	%ScoreLabel.text = "Score: %s  |  Length: %s" % [score, snake_length]
