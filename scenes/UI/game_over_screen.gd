extends VBoxContainer

@onready var retry_button: Button = %RetryButton
@onready var menu_button: Button = %MenuButton

func set_scores(score: int, snake_length: int):
	%ScoreLabel.text = "%s" % score
	%LengthLabel.text = "%s" % snake_length
