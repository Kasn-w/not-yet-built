extends Control
@onready var species: LineEdit = $species
@onready var stare: LineEdit = $starecy
@onready var tilt: LineEdit = $tilt
@onready var cosmic: OptionButton = $cosmic
@onready var present: OptionButton = $cosmic2
@onready var num_pre: AudioStreamPlayer = $num_pre
@onready var correct: AudioStreamPlayer = $correct
@onready var wrong: AudioStreamPlayer = $wrong

@onready var _1: Panel = $pa1
@onready var _2: Panel = $pa2
@onready var _3: Panel = $pa3
@onready var _4: Panel = $pa4
@onready var _5: Panel = $pa5

signal done

var c_specie := ["Emperor Penguin", "EmperorPenguin"]
var c_stare := "23"
var c_tilt := "45"
var c_cosmic = 1
var c_present = 0
var panel:Array = []
var corr:Array = [false,false,false,false,false]

func _ready() -> void:
	Global.ui = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
	panel.append(_1)
	panel.append(_2)
	panel.append(_3)
	panel.append(_4)
	panel.append(_5)
	for i in panel:
		i.hide()


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


func update_display() -> void:
	for i in panel:
		i.hide()
	check()
	await get_tree().create_timer(0.8).timeout
	for i in range(5):
		if (corr[i]):
			correct.play()
			panel[i].modulate = Color("04d31b")
		else:
			wrong.play()
			panel[i].modulate = Color("d7000bff")
		panel[i].show()
		await get_tree().create_timer(0.8).timeout
	if (check()):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		done.emit()
		off()


func _on_summit_pressed() -> void:
	num_pre.play()
	update_display()


func _on_x_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	off()

func check():
	var temp = true
	var spch = false
	for i in c_specie:
		if (i.strip_edges().to_lower() == species.text.strip_edges().to_lower()):
			corr[0] = true
			spch = true
			break
	if !spch:
		corr[0] = false
		temp = false
	
	if stare.text != c_stare:
		corr[1] = false
		temp = false
	else:
		corr[1] = true
		
	if tilt.text != c_tilt:
		corr[2] = false
		temp = false
	else:
		corr[2] = true
	
	if cosmic.selected != c_cosmic:
		corr[3] = false
		temp = false
	else:
		corr[3] = true
	
	if present.selected != c_present:
		corr[4] = false
		temp = false
	else:
		corr[4] = true
	
	return temp
