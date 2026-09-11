extends Control

@onready var text: LineEdit = $text
@onready var num_pre: AudioStreamPlayer = $num_pre

signal done
signal fail

var correct = "2026"

func _ready() -> void:
	Global.ui = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			off()
	elif event.is_action_pressed("ui_cancel") or event.is_action_pressed("click"):
		off()
			
func off():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.2)
	await tween.finished
	Global.ui = false
	queue_free()


func _on_summit_pressed() -> void:
	num_pre.play()
	if (text.text == correct):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		done.emit()
		off()
	else:
		fail.emit()
		text.text = ""


func _on_x_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	off()
