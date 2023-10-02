extends Control

func _ready():
	var env : Environment = $Main/WorldEnvironment.environment
	env.glow_enabled = false
