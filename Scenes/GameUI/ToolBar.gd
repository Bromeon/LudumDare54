extends NinePatchRect

@onready var slot_list = $MarginContainer/VBoxContainer

var inventory = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# The system will notify us each time a mineral is added by calling `add_item`
	GameData.register_mineral_observer(add_item)
	
	# Inventory starts empty
	for i in range(8):
		set_ui_slot_info(i, null, 0)
		

func set_ui_slot_info(i, mineral, amount):
	var slot = slot_list.get_child(i)
	
	if mineral != null:
		slot.get_node("TextureRect/Icon").visible = true
		slot.get_node("TextureRect/Icon").modulate = GameConstants.MINERAL_TYPE_COLORS[mineral]
		var text_str = ""
		if amount < 10:
			text_str = "0" + str(amount)
		else:
			text_str = str(amount)
		slot.get_node("HBoxContainer/Label").text = text_str
	else:
		slot.get_node("TextureRect/Icon").visible = false
		slot.get_node("HBoxContainer/Label").text = "--"

func add_item(mineral: String, amount: int):
	var i = 0
	for item in inventory:
		if item.mineral == mineral:
			item.amount += amount
			set_ui_slot_info(i, item.mineral, item.amount)
			return
		i += 1
		
	if i < 8:
		inventory.append({ mineral = mineral, amount = amount })
		set_ui_slot_info(i, mineral, amount)
	else:
		assert(false, "Should never happen, there's only 8 minerals")
