extends Node3D

@onready var child = get_children()

func _ready() -> void:
	light_off()

func light_off():
	for i in child:
		i.setlight_en(0)

func light_on():
	for i in child:
		i.light_on()
