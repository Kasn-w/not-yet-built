extends Node3D

@onready var iitem: item_col = $item
var col:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	iitem.collected.connect(_on_collect)

func _on_collect():
	if col == false:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector3(1.2,1.2,1.2), 0.2)
		tween.tween_property(self, "scale", Vector3(0,0,0), 0.3)
		await tween.finished
		queue_free()
