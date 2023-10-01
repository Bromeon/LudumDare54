extends Node

var mineral_amounts = {}

signal mineral_collected(mineral_type: String, amount: int)

func _ready():
	for mineral in GameConstants.MINERAL_NAMES:
		mineral_amounts[mineral] = 0

func register_mineral_observer(observer: Callable):
	self.connect("mineral_collected", observer)
	
func notify_mineral_collected(mineral_type: String, amount: int):
	if not mineral_amounts.has(mineral_type):
		mineral_amounts[mineral_type] = 0
	mineral_amounts[mineral_type] += amount
	self.emit_signal("mineral_collected", mineral_type, amount)
