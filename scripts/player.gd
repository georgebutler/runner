extends CharacterBody2D

# Movement
const SPEED = 300.0
const ACCELERATION = 1000.0
const DECELERATION = 2000.0
const ROTATION_ANGLE = 10.0
const VERTICAL_LIMIT_TOP = -150.0
const VERTICAL_LIMIT_BOTTOM = 140.0

# Recovery
const RECOVERY_TIME = 3.0

# Signals
signal hit
signal recovered

# Local
var can_move = true
var last_hit = -1

func _on_hit():
	print("Hit")
	await get_tree().create_timer(RECOVERY_TIME).timeout
	recovered.emit()
	
func _on_recovered():
	print("Recovered")

func _physics_process(delta):
	var input_vertical = Input.get_axis("move_up", "move_down")
	
	if can_move:			
		if input_vertical:
			velocity.y = move_toward(velocity.y, input_vertical * SPEED, ACCELERATION * delta)
			var target_rotation = deg_to_rad(ROTATION_ANGLE * input_vertical)
			rotation = lerp_angle(rotation, target_rotation, 0.1)
		else:
			velocity.y = move_toward(velocity.y, 0, DECELERATION * delta)
			rotation = lerp_angle(rotation, 0, 0.1)
	
	move_and_slide()
	
	global_position.y = clamp(global_position.y, VERTICAL_LIMIT_TOP, VERTICAL_LIMIT_BOTTOM)

func _on_area_2d_area_entered(_area):
	if (last_hit + 3000 <= Time.get_ticks_msec()):
		hit.emit()
		last_hit = Time.get_ticks_msec()
