extends Node

@export var main_menu_music: AudioStream
@export var level_one: PackedScene
@export var music_one: AudioStream
@export var level_two: PackedScene
@export var music_two: AudioStream
@export var level_three: PackedScene
@export var music_three: AudioStream

var current_level: Game = null

func _ready() -> void:
	#Connect MainMenu signals
	%MainMenu.start_button.pressed.connect(select_level)
	%MainMenu.quit_button.pressed.connect(quit_game)
	#Connect GameOver signals
	%GameOverScreen.menu_button.pressed.connect(open_menu)
	%GameOverScreen.retry_button.pressed.connect(start_new_game)
	#Connect LevelSelect signals
	%LevelSelectMenu.level_one_button.pressed.connect(load_level_one)
	%LevelSelectMenu.level_two_button.pressed.connect(load_level_two)
	%LevelSelectMenu.level_three_button.pressed.connect(load_level_three)
	#Connect DifficultySelect signals
	%DifficultySelectMenu.easy_button.pressed.connect(difficulty_easy)
	%DifficultySelectMenu.medium_button.pressed.connect(difficulty_medium)
	%DifficultySelectMenu.hard_button.pressed.connect(difficulty_hard)
	
	%MusicPlayer.stream = main_menu_music
	%MusicPlayer.play()

func game_over(score: int, snake_length: int):
	%MenuBackground.visible = true
	%GameOverScreen.visible = true
	%GameOverScreen.set_scores(score, snake_length)

func select_level():
	%MainMenu.visible = false
	%LevelSelectMenu.visible = true

func start_new_game():
	%MenuBackground.visible = false
	%DifficultySelectMenu.visible = false
	%GameOverScreen.visible = false
	current_level.start_new_game()

func quit_game():
	get_tree().quit()

func open_menu():
	%MenuBackground.visible = true
	%MainMenu.visible = true
	%GameOverScreen.visible = false
	switch_music(main_menu_music)

func load_level_one():
	if get_children().size() >= 3: get_child(2).queue_free()
	current_level = level_one.instantiate()
	add_child(current_level)
	current_level.died.connect(game_over)
	current_level.start_position = Vector2i(10, 10)
	switch_music(music_one)
	%LevelSelectMenu.visible = false
	%DifficultySelectMenu.visible = true

func load_level_two():
	if get_children().size() >= 3: get_child(2).queue_free()
	current_level = level_two.instantiate()
	add_child(current_level)
	current_level.died.connect(game_over)
	current_level.start_position = Vector2i(15, 10)
	switch_music(music_two)
	%LevelSelectMenu.visible = false
	%DifficultySelectMenu.visible = true

func load_level_three():
	if get_children().size() >= 3: get_child(2).queue_free()
	current_level = level_three.instantiate()
	add_child(current_level)
	current_level.died.connect(game_over)
	current_level.start_position = Vector2i(15, 10)
	switch_music(music_three)
	%LevelSelectMenu.visible = false
	%DifficultySelectMenu.visible = true

func difficulty_easy():
	current_level.difficulty = Refs.EASY
	start_new_game()

func difficulty_medium():
	current_level.difficulty = Refs.MEDIUM
	start_new_game()

func difficulty_hard():
	current_level.difficulty = Refs.HARD
	start_new_game()

func switch_music(music_1: AudioStream):
	var tween = get_tree().create_tween()
	tween.tween_property(%MusicPlayer, "volume_db", -80, 1)
	await tween.finished
	%MusicPlayer.stream = music_1
	%MusicPlayer.play()
	var tween2 = get_tree().create_tween()
	tween2.tween_property(%MusicPlayer, "volume_db", -20, 1)
