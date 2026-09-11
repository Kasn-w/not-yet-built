extends Node3D

@export var des:String = "Note"
@onready var ar: note = $Area3D
const display = preload("uid://e6oskj6oc3lj")
@onready var arcol: CollisionShape3D = $Area3D/CollisionShape3D

var op:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ar.read.connect(_read)


func _read():
	if (!op) and !has_node("Control"):
		var create = display.instantiate()
		
		add_child(create)
		
		create.setup(des)

	
