extends RigidBody2D

var Tether = preload("res://Scenes/PlayerShip/Tether.tscn")

@export var THRUSTER_FORCE = 800
@export var MAX_VELOCITY = 300
@export var ROTATION_SPEED = 1.0
@export var BRAKE_FACTOR = 0.05
@export var TETHER_SHOOT_COOLDOWN = 3.0

@export var MAX_TETHER_LENGTH = 500.0

const ROTATION_RATE := deg_to_rad(180)

# A ship can have at most two tethers. One of them will be attached to another #
# ship, and the second one will be used when trying to reattach the ship to #
# another object.
var tethers = []

var tether_shoot_cooldown_timer = 0.0

var move_dir = Vector2(0, 0)
var rotation_angle = 0.0
var current_attachment = null
var aim_dir = Vector2(1, 0)

# Time since last time the controller or mouse were used to aim. This is used in
# order to avoid the ship to aim at the mouse when the controller is being used
var last_controller_aim = 0
var last_mouse_aim = 0

# Attaches this ship to a node, so that it moves with it.
func attach_to(attachment_):
	current_attachment = attachment_
	
func _ready():
	$AimPivot.top_level = true

	
func current_attachment_position():
	if current_attachment != null:
		return current_attachment.node.global_position + current_attachment.offset
	else:
		return null
		
func cleanup_dead_tethers():
	var cleaned = []
	for tether in tethers:
		if is_instance_valid(tether):
			cleaned.append(tether)
	tethers = cleaned
	
func _physics_process(delta):
	# When mouse is used, the thrust force is relative to orientation
	if player_uses_mouse():
		var mouse_pos = get_global_mouse_position()
		var forward_is = Vector2.RIGHT.rotated(rotation_angle)
		var forward_should = mouse_pos - self.position
		
		#var cross = forward_is.cross(forward_should)
		var angle = forward_is.angle_to(forward_should)
		var rotation_rate = ROTATION_RATE * delta

		if angle >= 0:
			angle = min(angle, rotation_rate)
		else:
			angle = max(angle, -rotation_rate)
			
		rotation_angle += angle
		
		var input = Input.get_vector("Down", "Up", "Left", "Right")
#		$MainThrust.emitting = input.x > 0
#		$RightThrust.emitting = input.y < 0
#		$LeftThrust.emitting = input.y > 0
#		$ReverseThrust.emitting = input.x < 0
#		$ReverseThrust2.emitting = input.x < 0
#
#		$LeftThrust.process_material.direction = to_vec3(Vector2.UP + velocity)
#		$RightThrust.process_material.direction = to_vec3(Vector2.DOWN + velocity)

		var velocity = $MainThrust.to_local(self.linear_velocity * delta)
#		var velocity = self.linear_velocity
		adjust_emitter($MainThrust, Vector2.LEFT, input, velocity)
		adjust_emitter($RightThrust, Vector2.DOWN, input, velocity)
		adjust_emitter($LeftThrust, Vector2.UP, input, velocity)
		adjust_emitter($ReverseThrust, Vector2.RIGHT, input, velocity)
		adjust_emitter($ReverseThrust2, Vector2.RIGHT, input, velocity)

		move_dir = input.rotated(rotation_angle)
		
		
	
	else:
		move_dir = Input.get_vector("Left", "Right", "Up", "Down")
	
	
	apply_force(move_dir * THRUSTER_FORCE)
	if self.linear_velocity.length() > MAX_VELOCITY:
		self.linear_velocity = self.linear_velocity.normalized() * MAX_VELOCITY
	
	if Input.is_action_pressed("Brake"):
		apply_central_impulse(-linear_velocity * BRAKE_FACTOR)
	
	if move_dir.length() > 0:
		var target_angle = Vector2(1,0).angle_to(move_dir)
		rotation_angle = lerp_angle(rotation_angle, target_angle, delta * ROTATION_SPEED)

	self.rotation = rotation_angle
	$AimPivot.position = self.position
	
	# Global distance constraint for the tether
	if current_attachment != null:
		var distance_vector = self.global_position - current_attachment_position()
		if distance_vector.length() > MAX_TETHER_LENGTH:
			var new_distance_vector = distance_vector.normalized() * MAX_TETHER_LENGTH
			self.global_position = current_attachment_position() + new_distance_vector
			var radial_velocity = self.linear_velocity.dot(new_distance_vector.normalized()) * new_distance_vector.normalized()
			if radial_velocity.dot(current_attachment_position() - self.global_position) < 0:
				self.linear_velocity -= radial_velocity
						
	# Update the tethers
	cleanup_dead_tethers()
	for tether in tethers:
		tether.update_physics(delta)
	
	# Handle aim and shooting tether
	do_aim()
	if tether_shoot_cooldown_timer > 0:
		tether_shoot_cooldown_timer -= delta
	if Input.is_action_just_pressed("ShootTether"):
		shoot_tether()
	if Input.is_action_pressed("ShootLaser"):
		shoot_laser_tick(delta)
	else:
		$Laser.deactivate()
	
static func adjust_emitter(thrust: GPUParticles2D, axis: Vector2, input: Vector2, velocity: Vector2):
	# if there is a component in positive direction of axis
	thrust.emitting = input.dot(axis) < 0
	
#	print(velocity)
	# attempt to adjust to velocityw
	var material: ParticleProcessMaterial = thrust.process_material
#	material.direction = to_vec3( axis + velocity )
#	material.initial_velocity_min = 200 * velocity.length()
#	material.initial_velocity_max = 300 * velocity.length()

static func to_vec3(vec2: Vector2) -> Vector3:
	return Vector3(vec2.x, vec2.y, 0)
	
func do_aim():
	var aim_dir_joy = Input.get_vector("AimLeft", "AimRight", "AimUp", "AimDown")
	if aim_dir_joy.length() > 0:
		last_controller_aim = Time.get_ticks_msec()
		aim_dir = aim_dir_joy
	elif player_uses_mouse():
		var camera = get_viewport().get_camera_2d()
		var mouse_pos
		if camera != null:
			mouse_pos = camera.get_global_mouse_position()
		else:
			mouse_pos = get_viewport().get_mouse_position()
		aim_dir = (mouse_pos - self.global_position).normalized()

	$AimPivot.rotation = Vector2.RIGHT.angle_to(aim_dir)

func player_uses_mouse() -> bool:
	print("USES MOUSE", last_mouse_aim >= last_controller_aim)
	return last_mouse_aim >= last_controller_aim

func shoot_tether():
	if tether_shoot_cooldown_timer > 0:
		return
		
	tether_shoot_cooldown_timer = TETHER_SHOOT_COOLDOWN

	var tether = Tether.instantiate()
	add_child(tether)
	tether.init(aim_dir)
	tethers.append(tether)
	tether.connect("attached_to", _on_tether_attached)
	
func shoot_laser_tick(delta):
	var dss = get_world_2d().direct_space_state
	var params = PhysicsRayQueryParameters2D.new()
	params.collide_with_bodies = true
	params.collision_mask = 0x4 # Asteroid layer
	params.from = self.global_position
	params.to = self.global_position + aim_dir * 1000

	var result = dss.intersect_ray(params)
	if result.has("collider"):
		var asteroid = result["collider"]
		asteroid.deal_damage_tick(
			result.position,
			result.normal,
			delta,
		)
		$Laser.activate(self.global_position, result.position, true)
	else:
		$Laser.activate(self.global_position, params.to, false)
	
func setup_initial_tether(other_ship):
	var tether = Tether.instantiate()
	add_child(tether)
	tether.connect("attached_to", _on_tether_attached)
	tether.init(Vector2.ZERO, other_ship)
	tethers.append(tether)
		
func _on_tether_attached(attached_tether, attch):
	for t in tethers:
		if t != attached_tether:
			t.detach()
	self.attach_to(attch)

func _input(event):
	if event is InputEventMouseMotion:
		last_mouse_aim = Time.get_ticks_msec()
	if event is InputEventJoypadMotion:
		if event.axis_value > 0.1:
			last_controller_aim = Time.get_ticks_msec()
	if event is InputEventMouseButton:
		last_controller_aim = Time.get_ticks_msec()
