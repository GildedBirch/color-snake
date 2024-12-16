extends PanelContainer

func set_scores(score: int, snake_length: int):
	%ScoreLabel.text = "Score: %s" % score
	%LengthLabel.text = "Length %s" % snake_length

func _on_retry_button_pressed() -> void:
	pass # Replace with function body.

func _on_menu_button_pressed() -> void:
	pass # Replace with function body.
