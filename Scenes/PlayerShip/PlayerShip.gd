extends RigidBody2D

var Tether = preload("res://Scenes/PlayerShip/Tether.tscn")

@export var THRUSTER_FORCE = 200
@export var ROTATION_SPEED = 1.0
@export var BRAKE_FACTOR = 0.05

@export var MAX_TETHER_LENGTH = 500.0

# A ship can have at most two tethers. One of them will be attached to another #
# ship, and the second one will be used when trying to reattach the ship to #
# another object.
var tethers = []

var move_dir = Vector2(0, 0)
var rotation_angle = 0.0
var attached_to = null
var aim_dir = Vector2(1, 0)

# Time since last time the controller or mouse were used to aim. This is used in
# order to avoid the ship to aim at the mouse when the controller is being used
var last_controller_aim = 0
var last_mouse_aim = 0

# Attaches this ship to a node, so that it moves with it.
func attach_to(node: Node2D, local_offset: Vector2):
	attached_to = {
		node = node,
		local_offset = local_offset
	}
	
func attachment_point():
	if attached_to == null:
		return null
	else:
		return attached_to.node.global_position + attached_to.local_offset
		
func _ready():
	$AimPivot.top_level = true

func _physics_process(delta):
	move_dir = Input.get_vector("Left", "Right", "Up", "Down")
	apply_force(move_dir * THRUSTER_FORCE)
	
	if Input.is_action_pressed("Brake"):
		apply_central_impulse(-linear_velocity * BRAKE_FACTOR)
	
	if move_dir.length() > 0:
		var target_angle= Vector2(1,0).angle_to(move_dir)
		rotation_angle = lerp_angle(rotation_angle, target_angle, delta * ROTATION_SPEED)

	self.rotation = rotation_angle
	$AimPivot.position = self.position
	
	# Global distance constraint for the tether
	var attch = attachment_point()
	if attch != null:
		var distance_vector = self.global_position - attch
		if distance_vector.length() > MAX_TETHER_LENGTH:
			var new_distance_vector = distance_vector.normalized() * MAX_TETHER_LENGTH
			self.global_position = attch + new_distance_vector

	# Update the tethers
	if tethers.size() > 0:
		tethers[0].update_physics(delta, attch)
	if tethers.size() > 1:
		# The attached tether is always the first one.
		tethers[1].update_physics(delta, null)
	
	# Handle aim and shooting tether
	do_aim()
	if Input.is_action_just_pressed("ShootTether"):
		shoot_tether()
	
func do_aim():
	var aim_dir_joy = Input.get_vector("AimLeft", "AimRight", "AimUp", "AimDown")
	if aim_dir_joy.length() > 0:
		last_controller_aim = Time.get_ticks_msec()
		aim_dir = aim_dir_joy
	elif last_mouse_aim > last_controller_aim:
		var mouse_pos = get_viewport().get_mouse_position()
		aim_dir = (mouse_pos - self.global_position).normalized()

	$AimPivot.rotation = Vector2.RIGHT.angle_to(aim_dir)
	
func shoot_tether():
	if len(tethers) < 2:
		var tether = Tether.instantiate()
		add_child(tether)
		tether.init(aim_dir)
		tethers.append(tether)

func _input(event):
	if event is InputEventMouseMotion:
		last_mouse_aim = Time.get_ticks_msec()
