extends NinePatchRect


# Called when the node enters the scene tree for the first time.
func _ready():
	ninepatch.min_size = Vector2(40, 40)
	ninepatch.expand_margin_left = 10
	ninepatch.expand_margin_right = 10
	ninepatch.expand_margin_top = 10
	ninepatch.expand_margin_bottom = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
