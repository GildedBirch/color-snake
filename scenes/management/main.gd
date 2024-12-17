extends Node

func _ready() -> void:
	%Game.died.connect(game_over)
	#Connect MainMenu signals
	%MainMenu.start_button.pressed.connect(start_new_game)
	%MainMenu.quit_button.pressed.connect(quit_game)
	#Connect GameOver signals
	%GameOverScreen.menu_button.pressed.connect(open_menu)
	%GameOverScreen.retry_button.pressed.connect(start_new_game)

func game_over(score: int, snake_length: int):
	%MenuBackground.visible = true
	%GameOverScreen.visible = true
	%GameOverScreen.set_scores(score, snake_length)

func start_new_game():
	%MenuBackground.visible = false
	%MainMenu.visible = false
	%GameOverScreen.visible = false
	%Game.start_new_game()

func quit_game():
	get_tree().quit()

func open_menu():
	%MenuBackground.visible = true
	%MainMenu.visible = true
	%GameOverScreen.visible = false
