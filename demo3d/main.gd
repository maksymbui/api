extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	$UI/Retry.hide()

func _on_mob_timer_timeout():
	
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	add_child(mob)
	
	$UI/ScoreLabel.update_score()
	mob.squashed.connect($UI/ScoreLabel._on_mob_squashed.bind())
	
func _on_player_hit() -> void:
	$MobTimer.stop()
	$UI/Retry.show()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UI/Retry.visible:
		get_tree().reload_current_scene()
