class_name  light_bulb
extends Node3D

@onready var mesht: MeshInstance3D = $mesh
@onready var light: OmniLight3D = $light
@onready var timer: Timer = $Timer

@export var blink:bool = false
@export var blink_time:int = 10
@export var blink_time2:int = 20
@export var en_on:float = 1.3

var is_inani:bool = false
@onready var og = light.light_energy
var _tween: Tween
var flick
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mat = mesht.get_active_material(0)
	mat.albedo_color = light.get_color()
	
	if (has_node("flinker")):
		flick = $flinker

func _on_timer_timeout() -> void:
	if (!is_inani) and blink:
		if (has_node("flinker")):
			flick.play()
		is_inani = true
		var tween = get_tree().create_tween()
		tween.tween_property(light, "light_energy", 0, 0.1)
		tween.tween_property(light, "light_energy", og, 0.1)
		if (randi_range(0, 2) < 1):
			tween.tween_property(light, "light_energy", 0, 0.1)
			tween.tween_property(light, "light_energy", og, 0.1)
		is_inani = false
	if blink:
		timer.start(randi_range(blink_time, blink_time2))

func setlight_en(en):
	light.light_energy = en
	
func light_on():
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.tween_property(light, "light_energy", en_on, 0.8)
