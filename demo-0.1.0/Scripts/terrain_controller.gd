extends Node3D

@export var terrain :PackedScene
var terrain_render: Array[MeshInstance3D] = []
var terrain_velocity: float = 10
var active: bool = true

func _ready() -> void:
	_init_blocks()

func _physics_process(delta: float) -> void:
	if active:
		_progress_terrain(delta)

func _stop_gen() -> void:
	active = false

func _init_blocks() -> void:
	for block_index in 10:
		var block = terrain.instantiate()
		
		if block_index < 1:
			block.generate_empty()
		else:
			block.generate_obstacles()
			
		if block_index == 0:
			block.position.z = block.mesh.size.y/2
		else:
			append_to_edge(terrain_render[block_index -1], block)
		add_child(block)
		terrain_render.append(block)

func _progress_terrain(delta: float):	
	terrain_velocity += 0.001
	for block in terrain_render:
		block.position.z += terrain_velocity * delta
		
	if terrain_render[0].position.z >= terrain_render[0].mesh.size.y+100:
		var last_terrain = terrain_render[-1]
		var first_terrain = terrain_render.pop_front()
		
		var block = terrain.instantiate()
		block.generate_obstacles()
		append_to_edge(last_terrain, block)
		add_child(block)
		terrain_render.append(block)
		first_terrain.queue_free()

func append_to_edge(target_block: MeshInstance3D, appending_block: MeshInstance3D) -> void:
	appending_block.position.z = target_block.position.z - target_block.mesh.size.y/2 - appending_block.mesh.size.y/2	
