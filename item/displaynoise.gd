extends TextureRect

@export var speed:float = 50
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	texture.noise.offset += Vector3(0.0, speed * delta, 0.0)
