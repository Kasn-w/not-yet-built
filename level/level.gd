extends Node3D

@onready var keypat: Node3D = $keypad
@onready var officedoor: Node3D = $dooroff2/doorAR
@onready var researchdoor: Node3D = $doorre2/doorAR
@onready var all_light: Node3D = $alllight
@onready var dindoor1: door = $doordin/doorAR
@onready var dindoor2: door = $doordin2/doorAR
@onready var player: CharacterBody3D = $player
@onready var wall_break: AudioStreamPlayer = $wall_break
@onready var stor_wait: Node3D = $stor_wait
@onready var dark: TextureRect = $dark
@onready var getup: AudioStreamPlayer = $getup
@onready var stor_radio: Node3D = $stor_radio
@onready var world_environment: WorldEnvironment = $WorldEnvironment

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Setting.brightness_changed.connect(_update_brightness)
	Global.reset()
	player.lock = true
	var tween = create_tween()
	var tween2 = create_tween()
	getup.play()
	tween.tween_method(set_snow_vol, -80, 0, 1)
	tween2.tween_property(dark, "modulate", Color(0.0, 0.0, 0.0, 0.345), 1)
	tween2.tween_property(dark, "modulate", Color(0.0, 0.0, 0.0, 0.776), 0.5)
	tween2.tween_interval(0.5)
	tween2.tween_property(dark, "modulate", Color(0.0, 0.0, 0.0, 0.0), 2)
	await tween2.finished
	getup.queue_free()
	dark.queue_free()
	Global.just_start = false

func _open_office():
	officedoor.enable = true
	officedoor.opend()

func _open_research():
	researchdoor.enable = true
	researchdoor.opend()

func _on_keypad_donek() -> void:
	_open_office()


func _on_computer_donec() -> void:
	_open_research()


func _on_generator_gen_on() -> void:
	if (Global.gen_on != true):
		Global.gen_on = true
		player.sprint_e = true
		player.labeldisplay("Shift to run")
		all_light.light_on()
		stor_wait.queue_free()
		stor_radio.queue_free()
		dindoor1.enable = true
		dindoor2.enable = true


func _on_player_dead() -> void:
	player.global_position = Global.savepoint
	if Global.rota:
		player.global_rotation = Vector3(0,0,0)
	Global.time_nono = 0

func _on_breakwall_wbreak() -> void:
	player.darknow()
	wall_break.play()


func _on_gwencomputer_donegc() -> void:
	Global.kit_com = true
	Global.radio_playing = false
	player.radio_fstop()
	player.ping("Kitchen")
	Global.stor_what = "Go_for"


func set_snow_vol(vol):
	var index = AudioServer.get_bus_index("snow")
	AudioServer.set_bus_volume_db(index, vol)


func _on_gwencomputer_failgc() -> void:
	player.ping("fail")

func _update_brightness():
	world_environment.environment.ambient_light_energy = Setting.bright
