extends Node

signal died(score: int, snake_length: int)

const SNAKE_PART: PackedScene = preload("res://scenes/snake/snake_part.tscn")
const FOOD: PackedScene = preload("res://scenes/food/food.tscn")

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
enum {EASY, MEDIUM, HARD}
var difficulty: int = HARD
var score: int = 0
var snake_length: int:
	get():
		return %Snake.get_children().size()
var wall_tile_positions: Dictionary
var crossed_color: bool = false

@export var default_game_speed: float = 0.5
@onready var game_speed: float = default_game_speed
@export var tile_size: int = 16
@export var map_size: Vector2i = Vector2i(20, 15)

func _ready() -> void:
	died.connect(game_over)
	wall_tile_positions = get_walls()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("up"):
		input_direction = UP
	if Input.is_action_just_pressed("down"):
		input_direction = DOWN
	if Input.is_action_just_pressed("left"):
		input_direction = LEFT
	if Input.is_action_just_pressed("right"):
		input_direction = RIGHT
	if %Snake.get_child_count() >= 1:
		%Snake.get_child(0).set_head_rotation(%Snake.get_child(1).tile_position, DIR[input_direction])

func start_new_game():
	%Snake.get_children().all(func(snake_part): snake_part.queue_free(); return true)
	%Food.get_children().all(func(food): food.queue_free(); return true)
	for wall: Wall in %Walls.get_children():
		if wall.random_color: wall.color = Refs.difficulty_colors[difficulty].pick_random()
	score = 0
	input_direction = UP
	prev_dir = UP
	initialize_snake(3)
	%ScoreLabel.visible = true
	%ScoreLabel.text = "Score: %s  |  Length: %s" % [score, 3]
	%GameTickTimer.wait_time = game_speed
	%GameTickTimer.start()

func initialize_snake(length: int) -> void:
	var color = Refs.difficulty_colors[difficulty].pick_random()
	for i in range(length):
		var snake_part: SnakePart = SNAKE_PART.instantiate()
		%Snake.add_child(snake_part)
		snake_part.color = color
		snake_part.tile_position = Vector2i(floori(map_size.x/2), floori(map_size.y/2) + i)
		snake_part.position = Vector2i(
			floori(map_size.x/2)*tile_size,
			floori(map_size.y/2)*tile_size + i*tile_size
			)
	%Snake.get_child(0).part = SnakePart.HEAD
	%Snake.get_child(-1).part = SnakePart.TAIL
	update_snake_z_index()

func move(dir: int):
	if dir == -prev_dir: dir = prev_dir
	prev_dir = dir
	
	var prev_pos: Vector2i = %Snake.get_child(0).tile_position + DIR[dir]
	var prev_color: Color = %Snake.get_child(0).color
	if eat(prev_pos):
		update_snake_visuals()
		return
	if collide(prev_pos):
		died.emit(score, snake_length)
		return

	for snake_part: SnakePart in %Snake.get_children():
		var new_pos: Vector2i = prev_pos
		prev_pos = snake_part.tile_position
		snake_part.tile_position = new_pos
		var new_color: Color = prev_color
		prev_color = snake_part.color
		snake_part.color = new_color
		snake_part.position = tile_to_world_pos(snake_part.tile_position)

	update_snake_visuals()

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
		return true
	return false

func collide(prev_pos: Vector2i) -> bool:
	var snake_parts: Dictionary = {}
	for snake_part: SnakePart in %Snake.get_children().slice(1):
		snake_parts[snake_part.tile_position] = snake_part

	snake_parts.merge(wall_tile_positions)
	if snake_parts.has(prev_pos):
		if snake_parts[prev_pos].color != %Snake.get_child(0).color or crossed_color:
			print("ded")
			return true
		else:
			crossed_color = true
			print("Crossed")
			return false
	crossed_color = false
	return false

func add_snake_part(pos: Vector2i, food_color: Color):
	var snake_part: SnakePart = SNAKE_PART.instantiate()
	%Snake.add_child(snake_part)
	snake_part.color = food_color
	snake_part.tile_position = pos
	snake_part.position = tile_to_world_pos(pos)
	%Snake.get_child(0).part = SnakePart.BODY
	snake_part.part = SnakePart.HEAD
	%Snake.move_child(snake_part, 0)
	update_snake_z_index()

func update_snake_visuals() -> void:
	#Update Head
	var dir = input_direction
	if dir == -prev_dir: dir = prev_dir
	%Snake.get_child(0).set_head_rotation(%Snake.get_child(0).tile_position - DIR[input_direction], DIR[dir])
	#Update Tail
	%Snake.get_child(-1).set_tail_rotation(%Snake.get_child(-2).tile_position)
	#Update body
	var parts: Array = %Snake.get_children()
	for i in range(1, parts.size()-1):
		parts[i].sprite_flipped = false
		parts[i].set_body_rotation(parts[i+1].tile_position, parts[i-1].tile_position)

func update_snake_z_index() -> void:
	var i: int = 1000
	for snake_part: SnakePart in %Snake.get_children():
		snake_part.z_index = i
		i -= 1

func spawn_food():
	var pos: Vector2i = Vector2i(randi_range(1, map_size.x-2), randi_range(1, map_size.y-2))
	var food: Food = FOOD.instantiate()
	%Food.add_child(food)
	food.tile_position = pos
	food.position = tile_to_world_pos(pos)
	food.color = Refs.difficulty_colors[difficulty].pick_random()

func game_over(_score: int, _snake_length: int):
	%GameTickTimer.stop()
	%ScoreLabel.visible = false

func get_walls() -> Dictionary:
	var walls: Dictionary
	for wall: Wall in %Walls.get_children():
		walls[wall.tile_position] = wall
	return walls

func tile_to_world_pos(tile_position: Vector2i) -> Vector2i:
	return Vector2i(tile_position.x * tile_size, tile_position.y * tile_size)

func _on_game_tick_timer_timeout() -> void:
	move(input_direction)
	if randf() > 0.8:
		spawn_food()
	%ScoreLabel.text = "Score: %s  |  Length: %s" % [score, snake_length]
