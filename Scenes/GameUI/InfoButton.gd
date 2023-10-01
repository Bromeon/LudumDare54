extends TextureButton

@onready var panel = $"../HelpPanel"
@onready var initial_size = panel.size.y

var shown : bool = true

func _on_pressed():
	shown = not shown
	
	var panel = $"../HelpPanel"
func _process(delta):
	if Input.is_action_just_pressed("CloseInfo"):
		shown = not shown
		
	var target_size
	if shown:
		target_size = initial_size
	else:
		target_size = 0.0
	panel.size.y = lerp(panel.size.y, target_size, delta * 3)
	
	if panel.size.y == 24:
		panel.visible = false
	else:
		panel.visible = true
