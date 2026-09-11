extends Node3D

@onready var dark: TextureRect = $Control/dark
@onready var num_pre: AudioStreamPlayer = $num_pre
@onready var white: TextureRect = $Control/white
const setting = preload("uid://bb01lkrokclce")

var check:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	set_snow_vol(-80)
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(set_snow_vol, -80, 0, 0.5)
	tween.tween_property(white, "modulate", Color(0.0, 0.0, 0.0, 0.0),1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	num_pre.play()
	if (!check):
		check = true
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_method(set_snow_vol, 0, -80, 1)
		tween.tween_property(dark, "modulate", Color(0,0,0,1), 1)
		await tween.finished
		get_tree().change_scene_to_file("res://level/Level.tscn")

func set_snow_vol(vol):
	var index = AudioServer.get_bus_index("snow")
	AudioServer.set_bus_volume_db(index, vol)


func _on_button_pressed() -> void:
	dis_set()

func dis_set():
	var creaete = setting.instantiate()
	add_child(creaete)
	
