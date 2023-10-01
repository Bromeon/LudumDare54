extends SubViewportContainer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var size = get_viewport_rect().size
	var sizei = Vector2i(size)
	if $SubViewport.size != sizei:
		$SubViewport.size = sizei
