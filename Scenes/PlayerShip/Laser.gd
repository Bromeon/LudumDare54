extends Node2D

var start: Vector2
var end: Vector2

const DENSITY = 1

var active: bool = false

@onready var particles := $GPUParticles2D
@onready var particle_material: ParticleProcessMaterial = $GPUParticles2D.process_material

func deactivate():
	active = false
	particles.emitting = false
	start = Vector2.ZERO
	end = Vector2.ZERO

func activate(start_: Vector2, end_: Vector2):
	active = true
	particles.emitting = true
	start = start_
	end = end_
	
func _ready():
	particles.top_level = true

func _process(delta):
	if active:
		queue_redraw()
	else:
		return
		
#	print("beam_len: ", beam_length, "   box:  ", particle_material.emission_box_extents)
	
	#var global_tr_inv = self.global_transform.inverse()
	var global_tr_inv = Transform2D.IDENTITY
	var start_ = global_tr_inv * start
	var end_ = global_tr_inv * end
	var beam_length = start_.distance_to(end_)
	

#	self.rotation = (end_ - start_).angle()
#	self.position = start_ + Vector2(beam_length / 2, 0)
	
	var offset = Vector2(beam_length / 2, 0)
	var angle = (end_ - start_).angle()
	
	var rotated_offset = offset.rotated(angle)
	
	particles.rotation = angle
	particles.position = start_ + rotated_offset
	
	particles.amount = DENSITY * beam_length
	particle_material.emission_box_extents.x = beam_length / 2
#	print("beam: ", start_.round(), " -> ", end_.round())
	
	
# TODO: Use real drawing code, this is a placeholder
#func _draw():
#	return
#	var global_tr_inv = self.global_transform.inverse()
#	var start_ = global_tr_inv * start
#	var end_ = global_tr_inv * end
#	draw_line(start_, end_, Color(1, 0, 0, 0.2), 4)
