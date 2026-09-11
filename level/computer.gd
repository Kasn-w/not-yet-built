extends Node3D

@onready var keyar: keypad = $keyar
const discom = preload("uid://bboq16kw1sm5s")

var solve:bool = false

signal donec
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	keyar.kuse.connect(_on_use)


func _on_use():
	if (!has_node("diskey")) and !solve:
		var create = discom.instantiate()
		create.done.connect(_done)
		add_child(create)


func _done():
	solve = true
	keyar.queue_free()
	donec.emit()
	
