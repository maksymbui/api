extends CharacterBody3D

@export var MOVE_SPEED: float = 10
var target_lane: int = 1
var LANES: Array = [-4, 0, 4]
var gravity_pull: float = 24
var jump_velocity: float = 10
var slideState: bool = false
var landState: bool = false

signal hit

var target_velocity: Vector3 = Vector3.ZERO

func _ready():
	pass
	
func _physics_process(delta: float) -> void:

	
	var direction: Vector3 = Vector3.ZERO
	if Input.is_action_just_pressed("ui_left") and target_lane > 0:
		target_lane -= 1
	if Input.is_action_just_pressed("ui_right") and target_lane < 2:
		target_lane += 1
	
	if not is_on_floor():
		if landState:
			target_velocity.y = target_velocity.y - (gravity_pull * delta)
		else:
			target_velocity.y = target_velocity.y - ((gravity_pull + 5) * delta)
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		target_velocity.y = jump_velocity
		if slideState:
			$SlideTimer.stop()
			slideState = false
			
	if is_on_floor() and not slideState and not landState:
		$Human/AnimationPlayer.play("running")
	if not is_on_floor() and not landState:
		$Human/AnimationPlayer.play("Jump")
	
	if Input.is_action_just_pressed("ui_down") and is_on_floor():
		$SlideTimer.start()
		slideState = true
		slide()
		
	elif Input.is_action_just_pressed("ui_down") and not is_on_floor():
		$LandTimer.start()
		landState = true
		land()

	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		
	var target_x: float = LANES[target_lane]
	var current_x: float = global_transform.origin.x
	global_transform.origin.x = lerp(current_x, target_x, MOVE_SPEED * delta)
	velocity = target_velocity
	
	for collision_index in get_slide_collision_count():
		var collision = get_slide_collision(collision_index)
		if collision.get_collider() == null:
			continue
			
		if collision.get_collider().is_in_group("blocks"):
			hit.emit()
			
	move_and_slide()
	
func slide() -> void:
	$Human/AnimationPlayer.play("Slide")

func land() -> void:
	$Human/AnimationPlayer.play("Slide")

func _on_slide_timer_timeout() -> void:
	slideState = false

func _on_land_timer_timeout() -> void:
	landState = false
