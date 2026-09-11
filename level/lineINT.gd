extends LineEdit

var oldt = ""

func _ready():
	text_changed.connect(_on_text_changed)

func _on_text_changed(new_text: String):
	# Allow empty string, otherwise check if it is a valid integer
	if new_text == "" or new_text.is_valid_int():
		oldt = new_text
	else:
		text = oldt
		set_caret_column(text.length())
