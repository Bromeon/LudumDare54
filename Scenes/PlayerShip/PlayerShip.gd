extends RigidBody2D

@export var THRUSTER_FORCE = 100
@export var ROTATION_SPEED = 3.0
@export var BRAKE_FACTOR = 0.999

var move_dir = Vector2(0, 0)
var rotation_angle = 0.0

func _physics_process(delta):
	move_dir = Input.get_vector("Left", "Right", "Up", "Down")
	apply_force(move_dir * THRUSTER_FORCE)
	
	if Input.is_action_pressed("Brake"):
		apply_central_impulse(-linear_velocity * BRAKE_FACTOR)
	
	if move_dir.length() > 0:
		var target_angle= Vector2(1,0).angle_to(move_dir)
		rotation_angle = lerp_angle(rotation_angle, target_angle, delta * ROTATION_SPEED)

	self.rotation = rotation_angle
