extends HBoxContainer
	
func _ready():
	update_mineral_amounts()
	GameData.register_mineral_observer(on_mineral_added)
	
func on_mineral_added(_mineral_type: String, _amount: int):
	update_mineral_amounts()
	
func update_mineral_amounts():
	var i = 0;
	for vbox in get_children():
		for row in vbox.get_children():
			var mineral = GameConstants.MINERAL_NAMES[i]
			var required_amt = GameConstants.QUEST_REQUIREMENTS[mineral]
			row.get_node("Label").set_text("x " + str(required_amt))
			row.get_node("TextureRect").modulate = GameConstants.MINERAL_TYPE_COLORS[mineral]
			row.get_node("TextureRect").mineral = mineral # Set tooltip
			if GameData.mineral_amounts[mineral] >= required_amt:
				row.get_node("Label").set_text("OK")
			
			i += 1

