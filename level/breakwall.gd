extends Node3D

signal wbreak

func _on_door_ar_open() -> void:
	wbreak.emit()
	await get_tree().create_timer(0.6).timeout
	queue_free()
