extends AudioStreamPlayer

@export var what:String = "radio"
@export var tran:String = "des"
@onready var noise: AudioStreamPlayer = $noise

func _ready() -> void:
	pass
	
func meplay(from_position: float = 0.0) -> void:
	Global.radio_playing = true
	play(from_position)
	noise.play()
	var tween = get_tree().create_tween()
	tween.tween_property(noise, "volume_db", 0, 1)

func mestop():
	noise.stop()
	stop()

func _on_finished() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(noise, "volume_db", -80, 1)
	await tween.finished
	noise.stop()
	Global.radio_playing = false
