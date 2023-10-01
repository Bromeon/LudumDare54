extends StaticBody2D

var MinedResource = preload("res://Scenes/MiningSpot/MinedResource.tscn")

@export var ROTATION_SPEED: float = 0.5
@export var RESOURCE_SPREAD: float = 0.1
@export var HP_PER_DROP: float = 2
@export var RESOURCE_YIELD: int = 5

# The asteroid will drop one mineral each time its HP reaches zero.
# After dropping `RESOURCE_YIELD` minerals it is destroyed.
@onready var hp: float = HP_PER_DROP
@onready var resource_count: int = RESOURCE_YIELD

func _physics_process(delta):
	self.rotate(delta * ROTATION_SPEED)
	
func deal_damage_tick(hit_pos: Vector2, hit_normal: Vector2, strength: float):
	print(hp)
	# Damage is applied per tick
	hp -= strength 
	if hp <= 0:
		if resource_count > 0:
			drop_resource(hit_pos, hit_normal)
			resource_count -= 1
			hp = HP_PER_DROP
		else:
			# TODO: Juice explode
			queue_free()

# Drop a resource 
func drop_resource(hit_pos: Vector2, hit_normal: Vector2):
	var spread = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * RESOURCE_SPREAD
	var shoot_direction = (hit_normal + spread).normalized()
	var resource = MinedResource.instantiate()
	get_parent().add_child(resource)
	resource.global_position = hit_pos + shoot_direction * 5
	resource.apply_impulse(shoot_direction * 50)
	resource.rotation_speed = randf_range(-1, 1) * 2
	resource.rotation_degrees = randf_range(0, 360)
