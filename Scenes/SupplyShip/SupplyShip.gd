extends Path2D

#class_name SupplyShip

@export var color: Color
@export var hue: float = 0.0
@export var effect_radius: float
@export var speed: float
@export var is_rocket: bool

@onready var follow := $PathFollow2D
@onready var graphics := $PathFollow2D/Ship
@onready var total_path_length := self.curve.get_baked_length()

func _ready():
	var circle = CircleShape2D.new()
	circle.radius = self.effect_radius
	
	$PathFollow2D/Area2D/CollisionShape2D.shape = circle
	
	get_node("%Ship/%Sprite").material.set_shader_parameter("hue", hue)
	graphics.modulate = color
	var global_tr = self.global_transform
	
	var cur = global_tr * self.curve.get_point_position(0)
	var next = global_tr * self.curve.sample(0, 0.01)
	
	var direction = (next - cur).angle() + deg_to_rad(90)
	
	graphics.global_position = cur
	graphics.global_rotation = direction
	
	follow.progress_ratio = 0.9
	
	# HACK: We do some Scene tree surgery to change the Ship
	# sprite scene with an inherited version, but taking care
	# to keep the GpuParticles2D as is.
	if is_rocket:
		var gpu_particles = $PathFollow2D/Ship/GPUParticles2D
		gpu_particles.get_parent().remove_child(gpu_particles)
		var old_ship = $PathFollow2D/Ship
		old_ship.queue_free()
		var rocket_ship_scn = preload("res://Scenes/SupplyShip/SupplyRocket.tscn")
		var rocket_ship = rocket_ship_scn.instantiate()
		$PathFollow2D.add_child(rocket_ship)
		rocket_ship.add_child(gpu_particles)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follow.progress_ratio = wrapf(follow.progress_ratio + delta * speed / total_path_length, 0.0, 1.0)
	

