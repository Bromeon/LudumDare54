extends Node2D

@export var TETHER_SEGMENTS =10 
@export var SEGMENT_LENGTH = 32.0

var initialized = false;

# List of rope segments.
var points = []

func _ready():
	var global_pos = get_global_position()
	for i in range(TETHER_SEGMENTS):
		# Verlet integration requires storing the previous position.
		points.append({
			position = global_pos + Vector2(0, i * SEGMENT_LENGTH),
			prev_position = global_pos + Vector2(0, i * SEGMENT_LENGTH),
		})
		
func _physics_process(_delta):
	# The first point is always attached to this node
	points[0].position = get_global_position()
	
	# Update point positions.
	for point in points:
		var temp = point.position
		var velocity = point.position - point.prev_position
		point.position += velocity
		point.prev_position = temp
		
	# Satisfy constraints.
	for i in range(TETHER_SEGMENTS-1):
		var delta_v = points[i+1].position - points[i].position
		var delta_length = delta_v.length()
		var difference = (delta_length - SEGMENT_LENGTH) / delta_length
		var offset = delta_v * 0.5 * difference
		points[i].position += offset
		points[i+1].position -= offset

	# Redraw the rope.
	queue_redraw()

func _draw():
	var gtr_inv = self.global_transform.inverse()
	for i in range(TETHER_SEGMENTS-1):
		var p0 = gtr_inv * points[i].position
		var p1 = gtr_inv * points[i+1].position
		draw_line(p0, p1, Color(1, 1, 1, 1), 2.0)
