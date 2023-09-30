extends Node2D

@onready var sprite := $Icon 
@onready var supply_paths := $SupplyPaths
@onready var camera = $Camera2D
@onready var camera_should = $CameraShould
@onready var player = $PlayerShip

# Camera: how much direction (forward vector) and velocity vector contribute
const WEIGHT_FORWARD = 30
const WEIGHT_VELOCITY = 0.8
# How fast the camera catches up to "should" position
const CATCHUP_SPEED = 12

func _ready():
	print("MMO initializing...")
	
	camera_should.global_position = player.position
	camera_should.modulate = Color(1.0, 1.0, 1.0, 0.3)
	
		

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		return
	
	sprite.rotate(delta * 1.5)
	
	var forward = Vector2.RIGHT.rotated(player.rotation_angle)
	camera_should.position = player.position + WEIGHT_FORWARD * forward + WEIGHT_VELOCITY * player.linear_velocity

	camera.position += (camera_should.position - camera.position) * delta * CATCHUP_SPEED
