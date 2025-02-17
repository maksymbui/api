extends Label

var score: int = 0

func update_score():
	score += 1
	text = "Score: %s" % score
