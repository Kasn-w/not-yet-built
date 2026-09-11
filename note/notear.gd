class_name note
extends Area3D

@onready var coli: CollisionShape3D = $CollisionShape3D

signal read

func readed():
	read.emit()
