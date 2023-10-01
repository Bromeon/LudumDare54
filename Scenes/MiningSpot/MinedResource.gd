extends RigidBody2D

var rotation_speed = 0.1
var collected = false
var elapsed_since_collected = 0.0

@export var mineral_type = "Lanthanum"

func set_mineral_type(type):
	mineral_type = type
	$Mineral1.modulate = GameConstants.MINERAL_TYPE_COLORS[type]

func _physics_process(delta):
	$Mineral1.rotate(rotation_speed * delta)
	
	var player_pos = get_tree().get_nodes_in_group("Player")[0].global_position
	var dir = (player_pos - global_position).normalized()

	if not collected:
		apply_force(dir * 10000 * delta)

	if player_pos.distance_to(global_position) < 100:
		collected = true
		
	if collected == true:
		self.linear_velocity = self.linear_velocity * 0.9
		elapsed_since_collected += delta
		rotation_speed = rotation_speed * 1.1
		scale = scale * 0.99
		$Mineral1.modulate.a = $Mineral1.modulate.a * 0.99
		
		if elapsed_since_collected > 1.0:
			print("Collected a piece of ", mineral_type)
			queue_free()

