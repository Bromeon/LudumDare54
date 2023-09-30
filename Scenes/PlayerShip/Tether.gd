extends Node2D

const ATTACHABLE_PHYSICS_LAYER = 0x2

signal attached_to(this, target)

@export var TETHER_SEGMENTS = 20.0
@export var SEGMENT_LENGTH = 10.0
@export var SHOOT_FORCE = 200.0

var initialized = false;

# List of rope segments.
var points = []

var shoot_dir = Vector2.ZERO
var elapsed = 0.0
var has_been_detached : bool = false
var time_since_detached : float = 0.0

var current_attachment = null

var sprite_pool = []
func _ready():
	for i in range(TETHER_SEGMENTS-1):
		var sprite = Sprite2D.new()
		if i == 0:
			sprite.texture = preload("res://Assets/Sprites/Tether_End.png")
			sprite.flip_v = true
		elif i == TETHER_SEGMENTS-2:
			sprite.texture = preload("res://Assets/Sprites/Tether_End.png")
		else:
			sprite.texture = preload("res://Assets/Sprites/Tether_Center.png")
		sprite.centered = true
		add_child(sprite)
		sprite_pool.append(sprite)

func detach():
	has_been_detached = true

func current_attachment_position():
	if current_attachment != null:
		return current_attachment.node.global_position + current_attachment.offset
	else:
		return null

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
func update_physics(delta):
	elapsed += delta

	# The first point is always attached to this node
	points[0].position = get_global_position()
	
	# Set the position of the last point, depending on the state
	if has_been_detached:
		time_since_detached += delta
	elif current_attachment != null:
		points[TETHER_SEGMENTS-1].position = current_attachment_position()
	else:
		points[TETHER_SEGMENTS-1].position += shoot_dir * SHOOT_FORCE * delta
		
	# Update point positions.
	for point in points:
		var temp = point.position
		var velocity = point.position - point.prev_position
		point.position += velocity
		point.prev_position = temp
		
	# Satisfy constraints.

	# NOTE: Apply damping at first to simulate the tether being shot.
	var damping = clamp(elapsed * 0.85, 0.0, 1.0)

	# NOTE: Once the tether has been detached, we shrink the segment length to
	# simulate recoil
	var segment_length 
	if time_since_detached > 0:
		segment_length = clamp(
			SEGMENT_LENGTH - time_since_detached * 5,
			0,
			SEGMENT_LENGTH
		) 
	else:
		segment_length = SEGMENT_LENGTH

	for i in range(TETHER_SEGMENTS-1):
		var delta_v = points[i+1].position - points[i].position
		var delta_length = delta_v.length()
		if delta_length > 0.05:
			var difference = (delta_length - segment_length) / delta_length
			var offset = delta_v * 0.5 * difference

			# Apply damping when the rope is first shot.
			offset = offset * damping

			points[i].position += offset
			points[i+1].position -= offset
			
	# Check if we hit an attachable point.
	if current_attachment == null:
		var check_pos = points[TETHER_SEGMENTS-1].position
		var dss = get_world_2d().direct_space_state
		var params = PhysicsPointQueryParameters2D.new()
		params.collide_with_bodies = true
		params.collision_mask = ATTACHABLE_PHYSICS_LAYER
		params.position = check_pos

		var results = dss.intersect_point(params, 1)
		for result in results:
			current_attachment = {
				node = result.collider,
				offset = check_pos - result.collider.global_position,
			}
			emit_signal("attached_to", self, current_attachment)

	# Redraw the rope.
	update_draw()
	
	if time_since_detached > 3.0:
		queue_free()
	if elapsed > 5 and current_attachment == null:
		queue_free()
		
func update_draw():
	# Uncomment this to toggle the debug _draw line
	# queue_redraw()
	
	for i in range(TETHER_SEGMENTS-1):
		var p0 = points[i].position
		var p1 = points[i+1].position
		
		var dist = p0.distance_to(p1)
		var center = (p0 + p1) * 0.5
		var angle = p0.angle_to_point(p1)
		
		sprite_pool[i].global_position = center
		sprite_pool[i].global_rotation = angle + (PI / 2.0)
		sprite_pool[i].scale = Vector2(1.0, dist / 32.0) * 1.1
		
		if time_since_detached > 0:
			sprite_pool[i].modulate = Color(1.0, 1.0, 1.0, 1.0 - time_since_detached / 1.0)
		elif elapsed > 4.5 and current_attachment == null:
			sprite_pool[i].modulate = Color(1.0, 1.0, 1.0, 1.0 - (elapsed - 4.5) / 0.5)
		else:
			sprite_pool[i].modulate = Color(1.0, 1.0, 1.0, 1.0)
		

func _draw():
	pass
	#var gtr_inv = self.global_transform.inverse()
	#for i in range(TETHER_SEGMENTS-1):
		#var p0 = gtr_inv * points[i].position
		#var p1 = gtr_inv * points[i+1].position
		#draw_line(p0, p1, Color(1, 1, 1, 1), 2.0)
		
			

