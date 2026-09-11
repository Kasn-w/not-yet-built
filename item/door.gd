class_name door
extends Area3D

@onready var coli: CollisionShape3D = $CollisionShape3D
@onready var opendd: AudioStreamPlayer3D = $opendd

signal open

@export var enable:bool = false
@export var des:String = "Des"

func opend():
	if (enable):
		if (des != "Break"):
			opendd.play()
		open.emit()
	else:
		return des
		
func disa():
	coli.disabled = true
	
func enna():
	coli.disabled = false
