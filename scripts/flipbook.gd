extends Sprite2D

@export var framerate : float = 0.1
@export var pause_on_last_frame : bool = false

func animate():
	await get_tree().create_timer(framerate).timeout
	
	if frame + 1 >= hframes:
		if pause_on_last_frame:
			await get_tree().create_timer(2).timeout
		
		frame = 0
	else:
		frame = frame + 1
		
	animate()

func _ready():
	animate()
