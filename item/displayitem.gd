extends Control

@onready var nam: Label = $name
@onready var des: Label = $des
@onready var pic: TextureRect = $TextureRect2

func _ready() -> void:
	Global.ui = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)

func setup(_pic, _nam, _des):
	nam.text = _nam
	des.text = _des.replace("\\n", "\n\n")
	pic.texture = load(_pic)
	
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
