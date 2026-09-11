extends Control

func _ready() -> void:
	Global.ui = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			off()
	elif event.is_action_pressed("ui_cancel") or event.is_action_pressed("click") or event.is_action_pressed("map"):
		off()
			
func off():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.2)
	await tween.finished
	Global.ui = false
	queue_free()
