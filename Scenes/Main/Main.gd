extends Node2D

@onready
var sprite := $Icon

@onready
var supply_paths := $SupplyPaths

func _ready():
	print("MMO initializing...")


func _process(delta):
	sprite.rotate(delta * 1.5)

	for path in supply_paths.get_children():
		var follow: PathFollow2D = path.get_node("PathFollow2D")
		follow.progress_ratio += delta * 0.01
		
	
			
