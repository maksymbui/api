extends MeshInstance3D

@export var block: PackedScene
var LANES: Array = [-4, 0, 4]
var HEIGHT: Array = [0.5, 3.2]

@export_dir var block_dir = "res://Scenes/obstacles"

func generate_obstacles() -> void:
	var num = randi() % 4
	for i in num:
		var obstacle = block.instantiate()
		obstacle.position.y = HEIGHT.pick_random()
		obstacle.position.x = LANES.pick_random()
		add_child(obstacle)


func generate_empty() -> void:
	pass
