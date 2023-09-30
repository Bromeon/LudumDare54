extends Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	%Background.set_bg_offset(%Camera2D.global_position * 0.001)
