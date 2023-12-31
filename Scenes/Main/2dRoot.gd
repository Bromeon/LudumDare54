extends Node2D

@export var player_cheat: bool = false

@onready var supply_paths := $SupplyPaths
@onready var camera = $Camera2D
@onready var camera_should = $CameraShould
@onready var player = $PlayerShip

# Camera: how much direction (forward vector) and velocity vector contribute
const WEIGHT_FORWARD = 30
const WEIGHT_VELOCITY = 0.8
# How fast the camera catches up to "should" position
const CATCHUP_POS_SPEED = 2
# How much the velocity adjusts to the "ideal one" between 0.5 and 1
const CATCHUP_VEL_RATIO = 0.92

var camera_vel: Vector2

func _ready():
	print("MMO initializing...")
	
	camera_should.global_position = player.position
	camera_should.modulate = Color(1.0, 1.0, 1.0, 0.3)
	
	if not player_cheat:
		# NOTE: Change Supply2 below with the actual initial ship the player starts attached to
		$PlayerShip.setup_initial_tether($SupplyPaths/Supply2.get_node("%Ship"))
	
#	debug.top_level = true
	var rect = camera.get_viewport_rect()
#	debug.position = rect.position - rect.size / 2
	#debug.position = rect.position + Vector2(0, 300)

	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		return
	
	
	var forward = Vector2.RIGHT.rotated(player.rotation_angle)
	camera_should.position = player.position + WEIGHT_FORWARD * forward + WEIGHT_VELOCITY * player.linear_velocity
	
	var camera_should_vel = (camera_should.position - camera.position) * CATCHUP_POS_SPEED
	camera_vel = lerp(camera_should_vel, camera_vel, CATCHUP_VEL_RATIO)
	camera.position += camera_vel * delta
	
#	debug.text = str("forward:    ", (WEIGHT_FORWARD * forward).round(), "\n",
#			"velocity:   ", (WEIGHT_VELOCITY * player.linear_velocity).round(), "\n",
#			"catchup:    ",  ((camera_should.position - camera.position) * CATCHUP_SPEED).round(), "\n",
#			"camera_vel: ", (camera_vel).round())
