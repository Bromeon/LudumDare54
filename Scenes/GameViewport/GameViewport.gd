extends SubViewportContainer

func _ready():
	var env : Environment = $SubViewport/Main/WorldEnvironment.environment
	env.glow_enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
