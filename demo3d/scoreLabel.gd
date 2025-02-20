extends Label

var score = 0

func _on_mob_squashed():
	score += 10
	update_score()
	
func update_score():
	score += 1
	text = "Score: %s" % score
