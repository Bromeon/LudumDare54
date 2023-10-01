extends HBoxContainer
	
var mineral_amounts = {}

func _ready():
	update_mineral_amounts()
	GameData.register_mineral_observer(on_mineral_added)
	
func on_mineral_added(mineral_type: String, amount: int):
	if not mineral_amounts.has(mineral_type):
		mineral_amounts[mineral_type] = 0
	mineral_amounts[mineral_type] += amount
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
			if mineral_amounts.has(mineral) and mineral_amounts[mineral] >= required_amt:
				row.get_node("Label").set_text("OK")
			
			i += 1

