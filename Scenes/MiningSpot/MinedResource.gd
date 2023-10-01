extends RigidBody2D

var rotation_speed = 0.1

func _physics_process(delta):
	$Mineral1.rotate(rotation_speed * delta)
