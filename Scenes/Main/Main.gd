extends Node2D

@onready var sprite := $Icon 
@onready var supply_paths := $SupplyPaths

func _ready():
	print("MMO initializing...")
		

func _process(delta):
	sprite.rotate(delta * 1.5)

