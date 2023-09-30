extends Node2D

@onready
var sprite := $Icon

@onready
var supply_paths := $SupplyPaths

func _ready():
	print("MMO initializing...")

	for path in supply_paths.get_children():
		var follow: PathFollow2D = path.get_node("PathFollow2D")
		var curve: Curve2D = path.curve
		var ship = follow.get_node("Ship")
		
		var cur = curve.get_point_position(0)
		var next = curve.sample(0, 0.01)
		
		var direction = (next - cur).angle() + deg_to_rad(90)
		
		ship.global_position = cur
		ship.global_rotation = direction
		
		

func _process(delta):
	sprite.rotate(delta * 1.5)

	for path in supply_paths.get_children():
		var follow: PathFollow2D = path.get_node("PathFollow2D")
		follow.progress_ratio += delta * 0.01
		
	
			
