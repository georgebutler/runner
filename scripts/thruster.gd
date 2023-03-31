extends Node2D

func _process(_delta):
	if not get_parent(): return
	rotation = lerp_angle(rotation, -get_parent().rotation, 0.1)

func _on_sprite_2d_frame_changed():
	$Sprite2D/PointLight2D.energy = randf_range(1.0, 2)
