extends Area3D

@export var what:String = "generic"

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)



func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and !Global.radio_playing:
		if ("Walkie-talkie" in body.col_item):
			if (what == "After_gen"):
				if (Global.gen_on):
					body.ping(what)
					Global.stor_what = what
					queue_free()
			else:
				if (what == "Junction"):
					if !Global.juction:
						Global.juction = true
						body.ping(what)
				else:
					body.ping(what)
				if (what == "First_met"):
					Global.stor_what = "Junction"
				elif (what == "Junction"):
					Global.stor_what = "Storage"
				else:
					Global.stor_what = what
				
				if !(what.begins_with("In")):
					queue_free()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		pass
