extends Node2D

var start: Vector2
var end: Vector2

const DENSITY = 10

@onready var particles := $GPUParticles2D
@onready var particle_material: ParticleProcessMaterial = $GPUParticles2D.process_material

func set_endpoints(start_: Vector2, end_: Vector2):
	start = start_
	end = end_
	
func _process(delta):
	if self.visible:
		queue_redraw()
	else:
		return
		
	var beam_length = start.distance_to(end)
	print("beam_len: ", beam_length, "   box:  ", particle_material.emission_box_extents)
	
	particles.position.x = beam_length / 2
	particles.amount = DENSITY * beam_length
	particle_material.emission_box_extents.x = beam_length / 2
	
	
# TODO: Use real drawing code, this is a placeholder
func _draw():
	return
	var global_tr_inv = self.global_transform.inverse()
	var start_ = global_tr_inv * start
	var end_ = global_tr_inv * end
	draw_line(start_, end_, Color(1, 0, 0), 4)
