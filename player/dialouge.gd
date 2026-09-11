extends Node

signal radio_done

var repeat:Array = []
@onready var child = get_children()
var dialoug:Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in child:
		dialoug[i.what] = i
		i.finished.connect(_finish)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play(what):
	if (what == "First_met") or (what == "Kitchen") or (what == "Junction"):
		if (what not in repeat):
			repeat.append(what)
		else:
			what = "generic"
	if (!Global.radio_playing):
		dialoug[what].meplay()
		return dialoug[what].tran
	return ""
		
func _finish():
	radio_done.emit()

func fstop():
	for i in dialoug:
		dialoug[i].mestop()
