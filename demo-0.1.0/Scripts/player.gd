extends CharacterBody3D

@export var MOVE_SPEED: float = 10
var target_lane: int = 1
var LANES: Array = [-4, 0, 4]
var gravity_pull: float = 24
var jump_velocity: float = 10
var target_velocity: Vector3 = Vector3.ZERO
var state: String = "run"

signal hit



func _ready():
	pass
	
func _physics_process(delta: float) -> void:

	var direction: Vector3 = Vector3.ZERO

	#Changing Lanes
	if Input.is_action_just_pressed("ui_left") and target_lane > 0:
		target_lane -= 1
	if Input.is_action_just_pressed("ui_right") and target_lane < 2:
		target_lane += 1
	var target_x: float = LANES[target_lane]
	var current_x: float = global_transform.origin.x
	global_transform.origin.x = lerp(current_x, target_x, MOVE_SPEED * delta)
	velocity = target_velocity
	
	#Controlling animations and GravityPull
	if is_on_floor():
		if state == "run":
			$Human/AnimationPlayer.play("running")
		if state == "slide":
			$Human/AnimationPlayer.play("Slide")
	else:
		target_velocity.y = target_velocity.y - (gravity_pull * delta)
		if state == "slide":
			$Human/AnimationPlayer.play("Slide")
		else:
			$Human/AnimationPlayer.play("Jump")
		
	#Jumping
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor() and state != "slide":
			target_velocity.y = jump_velocity
		if is_on_floor() and state == "slide":
			$SlideTimer.stop()
			state = "run"
			target_velocity.y = jump_velocity
			
	#Sliding
	if Input.is_action_just_pressed("ui_down"):
		if is_on_floor() and state != "slide":
			state = "slide"
			$SlideTimer.start()
		if not is_on_floor():
			state = "slide"
			$SlideTimer.start()
	#CollisionDetection
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
	for collision_index in get_slide_collision_count():
		var collision = get_slide_collision(collision_index)
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("blocks"):
			hit.emit()
			
			
	move_and_slide()

func _on_slide_timer_timeout() -> void:
	state = "run"
