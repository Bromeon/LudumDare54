extends NinePatchRect

func _ready():
	self.visible = false
	GameData.register_quest_observer(on_quest_complete)

func on_quest_complete():
	$"../VictoryParticles".emitting = true
	$"../Credits".visible = true
	self.visible = true
	MusicManager.play_victory_music()
	
