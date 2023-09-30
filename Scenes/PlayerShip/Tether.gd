extends Node2D

@export var TETHER_SEGMENTS = 12
@export var SEGMENT_LENGTH = 32.0
@export var SHOOT_FORCE = 100.0

var initialized = false;

# List of rope segments.
var points = []

var shoot_dir = Vector2.ZERO
var elapsed = 0.0

func init(sh_dir):
	self.shoot_dir = sh_dir
	var global_pos = get_global_position()
	for i in range(TETHER_SEGMENTS):
		# Verlet integration requires storing the previous position.
		var pos = global_pos + sh_dir * i * SEGMENT_LENGTH * 0.1;
		points.append({
			position = pos,
			prev_position = pos,
		})
		
# Called from PlayerShip
func update_physics(delta, attached_to):
	elapsed += delta

	# The first point is always attached to this node
	points[0].position = get_global_position()
	
	if attached_to != null:
		# When attached to a target, we fix the last point to the target.
		points[TETHER_SEGMENTS-1].position = attached_to
	else:
		# When not attached, we assume this tether has been shot and move
		# it towards the shoot direction
		points[TETHER_SEGMENTS-1].position += shoot_dir * SHOOT_FORCE * delta
		
		
	# Update point positions.
	for point in points:
		var temp = point.position
		var velocity = point.position - point.prev_position
		point.position += velocity
		point.prev_position = temp
		
	# Satisfy constraints.
	var damping = clamp(elapsed * 0.85, 0.0, 1.0)
	for i in range(TETHER_SEGMENTS-1):
		var delta_v = points[i+1].position - points[i].position
		var delta_length = delta_v.length()
		if delta_length > 0.05:
			var difference = (delta_length - SEGMENT_LENGTH) / delta_length
			var offset = delta_v * 0.5 * difference

			# Apply damping when the rope is first shot.
			offset = offset * damping

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
