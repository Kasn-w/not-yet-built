extends AudioStreamPlayer3D

var og_db:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	og_db = volume_db
	volume_db = -80
	play()
	await get_tree().process_frame
	stream_paused = true
	volume_db = og_db


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func stop_fade(sec=0.2):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -70, sec)
	await tween.finished
	stop()
	volume_db = og_db

func pause_fade(sec=0.2):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -70, sec)
	await tween.finished
	stream_paused = true
	volume_db = og_db
