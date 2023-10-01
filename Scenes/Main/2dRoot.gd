extends Node2D

@onready var sprite := $Icon 
@onready var supply_paths := $SupplyPaths
@onready var camera = $Camera2D
@onready var camera_should = $CameraShould
@onready var player = $PlayerShip
@onready var debug = $Camera2D/Debug

# Camera: how much direction (forward vector) and velocity vector contribute
const WEIGHT_FORWARD = 30
const WEIGHT_VELOCITY = 0.8
# How fast the camera catches up to "should" position
const CATCHUP_SPEED = 2

var camera_vel: Vector2

func _ready():
	print("MMO initializing...")
	
	camera_should.global_position = player.position
	camera_should.modulate = Color(1.0, 1.0, 1.0, 0.3)
	
	# NOTE: Change Supply2 below with the actual initial ship the player starts attached to
	$PlayerShip.setup_initial_tether($SupplyPaths/Supply2.get_node("%Ship"))
	
#	debug.top_level = true
	var rect = camera.get_viewport_rect()
#	debug.position = rect.position - rect.size / 2
	debug.position = rect.position + Vector2(0, 300)

	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		return
	
	sprite.rotate(delta * 1.5)
	
	var forward = Vector2.RIGHT.rotated(player.rotation_angle)
	camera_should.position = player.position + WEIGHT_FORWARD * forward + WEIGHT_VELOCITY * player.linear_velocity
	
	var camera_should_vel = (camera_should.position - camera.position) * CATCHUP_SPEED
	camera_vel = lerp(camera_should_vel, camera_vel, 0.92)
	camera.position += camera_vel * delta
	
#	debug.text = str("forward:    ", (WEIGHT_FORWARD * forward).round(), "\n",
#			"velocity:   ", (WEIGHT_VELOCITY * player.linear_velocity).round(), "\n",
#			"catchup:    ",  ((camera_should.position - camera.position) * CATCHUP_SPEED).round(), "\n",
#			"camera_vel: ", (camera_vel).round())
