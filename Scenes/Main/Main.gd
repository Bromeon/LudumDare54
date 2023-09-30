extends Node2D

@onready
var sprite := $Icon

func _ready():
	print("MMO initializing...")


func _process(delta):
	sprite.rotate(delta * 1.5)
