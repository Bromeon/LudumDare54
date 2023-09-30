extends Path2D

#class_name SupplyShip

@export var color: Color
@export var effect_radius: float
@export var speed: float

@onready var follow := $PathFollow2D
@onready var graphics := $PathFollow2D/Ship

func _ready():
	var circle = CircleShape2D.new()
	circle.radius = self.effect_radius
	
	$PathFollow2D/Area2D/CollisionShape2D.shape = circle
	
	
	graphics.modulate = color
	
	var cur = self.curve.get_point_position(0)
	var next = self.curve.sample(0, 0.01)
	
	var direction = (next - cur).angle() + deg_to_rad(90)
	
	graphics.global_position = cur
	graphics.global_rotation = direction
	
	follow.progress_ratio = 0.9


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follow.progress_ratio = wrapf(follow.progress_ratio + delta * 0.01 * speed, 0.0, 1.0)
	
