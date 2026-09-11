extends Area3D

var pin: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	if pin:
		Global.time_nono += delta

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		pin = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		pin = false
