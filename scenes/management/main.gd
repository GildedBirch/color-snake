extends Node

const GAME_OVER_SCREEN = preload("res://scenes/UI/game_over_screen.tscn")

func _ready() -> void:
	%Game.died.connect(game_over)

func game_over(score: int, snake_length: int):
	var go_screen = GAME_OVER_SCREEN.instantiate()
	add_child(go_screen)
	go_screen.set_scores(score, snake_length)
