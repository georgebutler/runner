extends Node

@export var obstruction_scenes : Array[PackedScene] = []

# Containers
var obstruction_container = Node2D.new()

# Game Speed
var game_speed = 1.0
var game_speed_maximum = 10.0
var time_to_reach_maximum = 60.0
var time_elapsed = 0.0

# Background
var background_time = 0.0

func spawn_obstacle():
	var instance = obstruction_scenes[0].instantiate()
	obstruction_container.add_child(instance)
	
	var visibility = VisibleOnScreenNotifier2D.new()
	instance.add_child(visibility)
	visibility.rect = instance.get_node("CollisionShape2D").shape.get_rect()
	visibility.connect("screen_entered", func():
		visibility.connect("screen_exited", func():
			visibility.get_parent().queue_free()
		)
	)
	
	instance.global_position = Vector2(300, 0)
	
	await get_tree().create_timer(1).timeout
	spawn_obstacle()
	
func _ready():
	obstruction_container = Node2D.new()
	add_child(obstruction_container)
	spawn_obstacle()
	
func _physics_process(delta):
	# Game Speed
	if game_speed < 10:
		time_elapsed += delta
		var progress = time_elapsed / time_to_reach_maximum
		game_speed = lerpf(0, game_speed_maximum, progress)
		
		if progress >= 1.0:
			game_speed = game_speed_maximum
			time_elapsed = time_to_reach_maximum
	
	# Obstruction Movement
	for obstruction in obstruction_container.get_children():
		obstruction.global_position -= Vector2(game_speed * 100.0, 0) * delta
		
	# Background Movement
	var background_index = 0
	background_time += delta
	
	for layer in get_node("Background").get_children():
		background_index += 1
		layer.get_material().set_shader_parameter("time", background_time)
		layer.get_material().set_shader_parameter("motion", Vector2(0.01 * background_index * game_speed, 0))
