extends Node

var ui:bool = false
var gen_on:bool = false
var kit_com:bool = false
var time_nono:float = 0.0

var savepoint:Vector3 = Vector3()
var rota:bool = false

var just_start:bool = true
var juction:bool = false
var radio_playing = false
var stor_what = "First_met"

var normal: Dictionary = {}
func _ready() -> void:
	for property in get_script().get_script_property_list():
		var prop_name = property.name
		if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			normal[prop_name] = get(prop_name)

func reset() -> void:
	for prop_name in normal:
		set(prop_name, normal[prop_name])
