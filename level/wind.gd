extends AudioStreamPlayer3D
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _on_timer_timeout() -> void:
	play()
	timer.start(randf_range(20,60))
