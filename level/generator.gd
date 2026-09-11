extends Node3D

signal gen_on

@onready var door_ar: door = $doorAR
var op:bool = false
@onready var gen_power: AudioStreamPlayer3D = $gen_power

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	door_ar.open.connect(_on_open)


func _on_open():
	gen_on.emit()
	await get_tree().create_timer(1.5).timeout
	gen_power.play()
