extends Control

signal done
@onready var label: Label = $label
@onready var grid: GridContainer = $GridContainer
@onready var _0: Button = $"0"
@onready var num_pre: AudioStreamPlayer = $num_pre
@onready var wrong: AudioStreamPlayer = $wrong

var correct_code := "2707"
var entered_code := ""

func _ready() -> void:
	Global.ui = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
	update_display()
	for i in range(9):
		var btn: Button = grid.get_child(i)
		btn.pressed.connect(num_press.bind(str(btn.name)))
	_0.pressed.connect(num_press.bind("0"))

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

func num_press(d):
	num_pre.play()
	if entered_code.length() < 8:
		entered_code += d
		update_display()


func update_display() -> void:
	label.text = entered_code.pad_zeros(0) if entered_code != "" else "______"

func _on_clear_pressed() -> void:
	num_pre.play()
	entered_code = ""
	update_display()


func _on_summit_pressed() -> void:
	num_pre.play()
	if entered_code == correct_code:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		done.emit()
		off()
	else:
		wrong.play()
		_on_clear_pressed()


func _on_x_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	off()
