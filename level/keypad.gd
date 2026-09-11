extends Node3D

@onready var key_ar: keypad = $keyAR
const display = preload("uid://q1ejap7p8cmn")

var solve:bool = false

signal donek
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	key_ar.kuse.connect(_on_use)


func _on_use():
	if (!has_node("diskey")) and !solve:
		var create = display.instantiate()
		create.done.connect(_done)
		add_child(create)
		
func _done():
	solve = true
	key_ar.queue_free()
	donek.emit()
	
