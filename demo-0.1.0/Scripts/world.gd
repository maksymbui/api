extends Node3D

func _ready() -> void:
	$UI/Retry.hide()
	$MainTimer.start()

func _physics_process(delta: float) -> void:
	pass

func _on_main_timer_timeout() -> void:
	$UI/ScoreLabel.update_score()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and $UI/Retry.visible:
		get_tree().reload_current_scene()

func _on_player_hit() -> void:
	$TerrainController._stop_gen()
	$MainTimer.stop()
	$UI/Retry.show()
