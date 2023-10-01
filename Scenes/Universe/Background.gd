extends ColorRect


func set_bg_offset(vel: Vector2):
	var sh = material as ShaderMaterial
	sh.set_shader_parameter("offset", vel)
	
