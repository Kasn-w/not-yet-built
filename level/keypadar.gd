class_name keypad
extends Area3D

@onready var coli: CollisionShape3D = $CollisionShape3D

signal kuse

func oper():
	kuse.emit()
