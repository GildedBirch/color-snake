extends PanelContainer

@onready var retry_button: Button = %RetryButton
@onready var menu_button: Button = %MenuButton

func set_scores(score: int, snake_length: int):
	%ScoreLabel.text = "Score: %s" % score
	%LengthLabel.text = "Length %s" % snake_length
