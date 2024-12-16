extends PanelContainer

func set_scores(score: int, snake_length: int):
	%ScoreLabel.text = "Score: %s" % score
	%LengthLabel.text = "Length %s" % snake_length
