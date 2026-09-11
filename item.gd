class_name item_col
extends Area3D

signal collected

@export var nam:String = "Item"
@export var des:String = "Des"
@export var pic:String = "Picpath"

func collect():
	collected.emit()
	return [pic, nam, des]
