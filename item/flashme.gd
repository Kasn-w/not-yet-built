extends OmniLight3D

@onready var iitem: item_col = $"../item"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	iitem.collected.connect(_on_collect)

func _on_collect():
	queue_free()
