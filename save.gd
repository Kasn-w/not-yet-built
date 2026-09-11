extends Marker3D

@export var rotaa:bool = false

func _on_save_point_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Global.savepoint = self.global_position
		Global.rota = rotaa
