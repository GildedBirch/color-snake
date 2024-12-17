extends Node

func _ready() -> void:
	%Game.died.connect(game_over)
	%GameOverScreen.menu_button.pressed.connect(open_menu)
	%GameOverScreen.retry_button.pressed.connect(start_new_game)

func game_over(score: int, snake_length: int):
	%GameOverScreen.visible = true
	%GameOverScreen.set_scores(score, snake_length)

func start_new_game():
	%GameOverScreen.visible = false
	%Game.start_new_game()

func open_menu():
	pass
