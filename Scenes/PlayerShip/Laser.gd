extends Node2D

var start: Vector2
var end: Vector2

func set_endpoints(start_: Vector2, end_: Vector2):
	start = start_
	end = end_
	
func _process(delta):
	if self.visible:
		queue_redraw()
	
# TODO: Use real drawing code, this is a placeholder
func _draw():
	var global_tr_inv = self.global_transform.inverse()
	var start_ = global_tr_inv * start
	var end_ = global_tr_inv * end
	draw_line(start_, end_, Color(1, 0, 0), 4)
