extends NinePatchRect

func initialize(mineral: String):
	%MineralIcon.modulate = GameConstants.MINERAL_TYPE_COLORS[mineral]
	%MineralName.text = mineral
	%MineralDescription.text = GameConstants.MINERAL_DESCRIPTIONS[mineral]
