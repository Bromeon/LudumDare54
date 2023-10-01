extends HBoxContainer

func _ready():
	var i = 0;
	for vbox in get_children():
		for row in vbox.get_children():
			var mineral = GameConstants.MINERAL_NAMES[i]
			row.get_node("TextureRect").modulate = GameConstants.MINERAL_TYPE_COLORS[mineral]
			row.get_node("TextureRect").mineral = mineral # Set tooltip
			row.get_node("Label").set_text("x " + str(GameConstants.QUEST_REQUIREMENTS[mineral]))
			i += 1
