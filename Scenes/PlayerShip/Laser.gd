extends Node2D

var start: Vector2
var end: Vector2

const DENSITY = 10

@onready var beam := $Beam
@onready var beam_material: ParticleProcessMaterial = $Beam.process_material
@onready var impact := $Impact
@onready var impact_material: ParticleProcessMaterial = $Impact.process_material

var ticks = 0

func deactivate():	
	beam.emitting = false
	impact.emitting = false
	start = Vector2.ZERO
	end = Vector2.ZERO
	$SFX.playing = false

func activate(start: Vector2, end: Vector2, hits_target: bool):
	beam.emitting = true
	impact.emitting = hits_target
	self.start = start
	self.end = end
	if not $SFX.playing and not ticks == 0: 
		$SFX.playing = true
		
		
# Fun workaround: on Web, particle system takes time to initialize. So pre-warm it
func warmup():
	activate(Vector2(2000, 2000), Vector2(2100, 2000), true)
	await get_tree().process_frame
	deactivate()
	
func _ready():
	beam.top_level = true
	impact.top_level = true
	
func _process(delta):
	# not in ready(), because process_frame waits for NEXT frame, so we need 2
	if ticks == 0:
		warmup()
	ticks += 1
	
	if not beam.emitting:
		return
		
#	print("beam_len: ", beam_length, "   box:  ", beam_material.emission_box_extents)
	
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
	
	beam.rotation = angle
	beam.position = start_ + rotated_offset
	
	if impact.emitting:
		impact.position = end
		impact.rotation = angle #+ PI
	
	# can't dynamically change amount: https://github.com/godotengine/godot/issues/16352
	#beam.amount = DENSITY * beam_length
	beam_material.emission_box_extents.x = beam_length / 2
#	print("beam: ", start_.round(), " -> ", end_.round())
	
	
# TODO: Use real drawing code, this is a placeholder
#func _draw():
#	return
#	var global_tr_inv = self.global_transform.inverse()
#	var start_ = global_tr_inv * start
#	var end_ = global_tr_inv * end
#	draw_line(start_, end_, Color(1, 0, 0, 0.2), 4)
