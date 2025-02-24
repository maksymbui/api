extends MeshInstance3D

@export var block: PackedScene
@export var train: PackedScene
@export var high_block: PackedScene

var LANES: Array = [-4, 0, 4]
var HEIGHT: Array = [0.5, 3.2]
var CHOICE: Array = ["block", "train","high_block","empty"]

func generate_obstacles() -> void:
	var train_count: int = 0
	for i in LANES:
		var choice: String = CHOICE.pick_random()
		if choice == "train" and train_count <= 2:
			var obstacle = train.instantiate()
			obstacle.position.x = i
			add_child(obstacle)
			train_count += 1
		elif choice == "block":
			var obstacle = block.instantiate()
			obstacle.position.x = i
			add_child(obstacle)
		elif choice == "high_block":
			var obstacle = high_block.instantiate()
			obstacle.position.x = i
			add_child(obstacle)
		else:
			pass

func generate_empty() -> void:
	pass
