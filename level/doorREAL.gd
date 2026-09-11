extends Node3D

@onready var door_ar: door = $doorAR
@onready var og: Vector3 = global_position
var op:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	door_ar.open.connect(_on_open)


func _on_open():
	if (!op):
		door_ar.disa()
		var tween = create_tween()
		var direct = global_transform.basis.x.normalized()
		var target_position = global_position + direct * 1.4 * scale.x
		
		tween.tween_property(self, "global_position", target_position, 0.8)
		await tween.finished
		door_ar.visible = true
		door_ar.enna()
		op = true
	else:
		door_ar.disa()
		var tween = create_tween()
		
		tween.tween_property(self, "global_position", og, 0.8)
		await tween.finished
		door_ar.enna()
		op = false
