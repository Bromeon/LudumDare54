extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerShip.attach_to($Anchor, Vector2.ZERO)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
