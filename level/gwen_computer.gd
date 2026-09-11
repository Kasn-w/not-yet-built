extends Node3D

@onready var keyar: keypad = $keyar
const discom = preload("uid://txe7wdb0awsq")

var solve:bool = false

signal donegc
signal failgc
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	keyar.kuse.connect(_on_use)


func _on_use():
	if (!has_node("diskey")) and !solve:
		var create = discom.instantiate()
		create.done.connect(_done)
		create.fail.connect(_fail)
		add_child(create)


func _done():
	solve = true
	keyar.queue_free()
	donegc.emit()

func _fail():
	failgc.emit()
