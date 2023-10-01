extends TextureRect

var ResourceTooltip = preload("res://Scenes/GameUI/ResourceTooltip.tscn")

@export var mineral : String
var game_ui: Control
var active_tooltip : Control
var is_mouse_over: bool

func _ready():
	connect("mouse_exited", _on_mouse_exited)
	connect("mouse_entered", _on_mouse_entered)
	
	var parent = get_parent()
	while parent.name != "GameUI":
		parent = parent.get_parent()
	game_ui = parent
	
func _on_mouse_exited():
	if active_tooltip != null:
		active_tooltip.queue_free()
	active_tooltip = null
	is_mouse_over = false
	
func _on_mouse_entered():
	is_mouse_over = true

func _input(event):
	if event is InputEventMouseMotion:
		if not self.get_global_rect().has_point(event.position):
			return
			
		if active_tooltip == null:
			active_tooltip = custom_tooltip()

		if active_tooltip != null:
			active_tooltip.position = get_global_mouse_position() + Vector2(10, 10)
			if active_tooltip.position.x + active_tooltip.get_global_rect().size.x > game_ui.get_global_rect().size.x:
				active_tooltip.position.x = game_ui.get_global_rect().size.x - active_tooltip.get_global_rect().size.x
			if active_tooltip.position.y + active_tooltip.get_global_rect().size.y > game_ui.get_global_rect().size.y:
				active_tooltip.position.y = game_ui.get_global_rect().size.y - active_tooltip.get_global_rect().size.y

			
func custom_tooltip():
	if mineral == "" or mineral == null:
		return null
	var tooltip = ResourceTooltip.instantiate()
	game_ui.add_child(tooltip)
	tooltip.initialize(mineral)
	return tooltip
	
func _process(_delta):
	if not is_mouse_over or mineral == "" or mineral == null:
		return
	else:
		if Input.is_action_just_pressed("CheatPlus1"):
			GameData.notify_mineral_collected(mineral, 1)
		if Input.is_action_just_pressed("CheatPlus10"):
			GameData.notify_mineral_collected(mineral, 10)
