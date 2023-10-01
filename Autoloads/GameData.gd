extends Node

signal mineral_collected(mineral_type: String, amount: int)

func register_mineral_observer(observer: Callable):
	self.connect("mineral_collected", observer)
	
func notify_mineral_collected(mineral_type: String, amount: int):
	self.emit_signal("mineral_collected", mineral_type, amount)
