extends Control

@onready var thank: Label = $thank

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween3 = create_tween()
	tween3.tween_method(set_snow_vol, 0, 2, 1.5)
	var tween = create_tween()
	tween.tween_property(thank, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2)
	tween.tween_interval(3)
	tween.tween_property(thank, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1)
	var tween2 = create_tween()
	tween2.tween_interval(5)
	tween2.tween_method(set_snow_vol, 2, -80, 3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_snow_vol(vol):
	var index = AudioServer.get_bus_index("snow")
	AudioServer.set_bus_volume_db(index, vol)

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://title.tscn")
