extends Control
@onready var volslider: HSlider = $volslider
@onready var senslider: HSlider = $senslider
@onready var check_box: CheckBox = $CheckBox
@onready var brightslider: HSlider = $brightslider
@onready var disvol: Label = $disvol
@onready var dissen: Label = $dissen
@onready var disbright: Label = $disbright


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.ui = true
	volslider.value = Setting.volume
	senslider.value = Setting.sensitive
	brightslider.value = Setting.bright
	check_box.button_pressed = Setting.invert_Y
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (volslider.value >= 10):
		disvol.text = " " + str(volslider.value)
	elif (volslider.value >= 0):
		disvol.text = "  " + str(volslider.value)
	elif (volslider.value > -10):
		disvol.text = " " + str(volslider.value)
	else:
		disvol.text = str(volslider.value)
	dissen.text = str(senslider.value)
	disbright.text = str(brightslider.value)
	set_vol(volslider.value)

func off():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.2)
	await tween.finished
	Global.ui = false
	if (get_parent().is_in_group("player")):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()

func _on_x_pressed() -> void:
	off()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		off()

func set_vol(vol):
	AudioServer.set_bus_volume_db(0, vol)
	AudioServer.set_bus_volume_db(1, vol)
	AudioServer.set_bus_volume_db(2, vol)

func _on_volslider_drag_ended(value_changed: bool) -> void:
	Setting.volume = volslider.value
	senslider.value = Setting.sensitive
	check_box.button_pressed = Setting.invert_Y


func _on_senslider_drag_ended(value_changed: bool) -> void:
	Setting.sensitive = senslider.value


func _on_check_box_pressed() -> void:
	if (check_box.button_pressed):
		Setting.invert_Y = true
	else:
		Setting.invert_Y = false


func _on_brightslider_drag_ended(value_changed: bool) -> void:
	Setting.bright = brightslider.value
	Setting.brightness_changed.emit()
