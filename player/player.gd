extends CharacterBody3D

signal dead

const disitem = preload("uid://dagc4ph4jhc4c")
const map = preload("uid://wae7dygfhybd")
const end = preload("uid://7ijmwaypcaqu")
const setting = preload("uid://bb01lkrokclce")

@onready var glitch: ColorRect = $glitch
@onready var dark: TextureRect = $dark
@onready var white: TextureRect = $white

@onready var cam: Camera3D = $Camera3D
@onready var flash = %flashlight
@onready var dot: TextureRect = $TextureRect2
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var label: Label = $click
@onready var footstepw: AudioStreamPlayer3D = $footstepw
@onready var footstepr: AudioStreamPlayer3D = $footstepr
@onready var flashlight_tog: AudioStreamPlayer = $flashlight_tog
@onready var map_look: AudioStreamPlayer = $map_look
@onready var pickup: AudioStreamPlayer = $pickup
@onready var glitch_1: AudioStreamPlayer = $glitch1
@onready var glitch_reset: AudioStreamPlayer = $glitch_reset
@onready var sub_la: Label = $sub
@onready var dialouge: Node = $Dialouge
@onready var windoor: AudioStreamPlayer = $windoor

@export var speed:float = 10
@export var max:float = 50
@export var gravity:float = 30

var flight_en:float = 0.3
var col_item:Array = []
var icheck:bool = false
var lock:bool = true
var sensitive:float = 0.2
var isblink:bool = false
var reading:bool = false

var old_nono:float = 0.0
var nono_counter:float = 0.0

var sprint_e:bool = false
var og_sp:float = 0
var moving:bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	og_sp = speed
	flash.light_energy = 0

func _physics_process(delta: float) -> void:
	#--glitch--
	if (Global.time_nono > 8):
		if (!glitch_reset.playing):
			glitch_reset.play()
		blink()
	if (Global.time_nono == old_nono) and (old_nono != 0):
		nono_counter += delta
	else:
		old_nono = Global.time_nono
	if (nono_counter >= 2):
		glitch_off()
	elif (Global.time_nono > 0.07):
		glitch.visible = true
		sprint_e = false
		speed = og_sp - clamp(((Global.time_nono + 3)/8)*(og_sp), 0, og_sp-1)
		glitch.modulate = Color(1,1,1,((Global.time_nono)/8)*1)
		if (Global.time_nono < 6) and !glitch_1.playing:
			glitch_1.play()
		if (Global.time_nono < 6):
			glitch_1.volume_db = -15 + (((Global.time_nono)/8)*3)
		else:
			glitch_1.volume_db = -15 + (((Global.time_nono)/8)*5)
		
	
	var direction2D:Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction3D:Vector3 = Vector3(direction2D.x, 0.0, direction2D.y)
	var direction:Vector3 = transform.basis * direction3D
	
	velocity.y -= gravity * delta
	
	var uses:float = 0
	if (Input.is_action_pressed("run")) and (sprint_e):
		uses = max
	else:
		uses = speed
	
	if direction3D:
		velocity.x = direction.x * uses
		velocity.z = direction.z * uses
	else:
		velocity.x = move_toward(velocity.x, 0, uses)
		velocity.z = move_toward(velocity.z, 0, uses)
	
	var see = raycast.get_collider()
	if (see is item_col) or (see is door) or (see is note) or (see is keypad):
		seeitem()
	
	else:
		if (dot.modulate == Color("ffffffff")):
			var tween = get_tree().create_tween()
			tween.tween_property(dot, "modulate", Color("ffffff00"), 0.2)
	
	playfootstep(velocity, uses)
	if (!lock):
		move_and_slide()
		
	if (!Global.ui and lock) and !(Global.just_start):
		lock = false
		

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and (!lock or Global.just_start):
		rotation_degrees.y -= event.relative.x * Setting.sensitive
		if cam.rotation_degrees.x <= 60 and cam.rotation_degrees.x >= -60:
			if (Setting.invert_Y):
				cam.rotation_degrees.x += event.relative.y * Setting.sensitive
			else:
				cam.rotation_degrees.x -= event.relative.y * Setting.sensitive
		if cam.rotation_degrees.x > 60:
			cam.rotation_degrees.x = 60
		if cam.rotation_degrees.x < -60:
			cam.rotation_degrees.x = -60
	elif event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			lock = false
			if (!icheck):
				icheck = true
				var see = raycast.get_collider()
				if (see is item_col):
					pickup.play()
					var temp = see.collect()
					await get_tree().create_timer(0.5).timeout
					if !lock:
						lock = true
					col_item.append(temp[1])
					displayitem(temp[0], temp[1], temp[2])
				elif (see is door):
					var temp = see.opend()
					if (temp == "Need Master Keycard" and "Master Keycard" in col_item):
						win()
					elif (temp == "Need Keycard" and "Keycard" in col_item) or (temp == "No Power" and true):
						see.enable = true
						see.opend()
					elif temp:
						labeldisplay(temp)
				elif (see is note):
					if !lock:
						lock = true
					see.readed()
				elif (see is keypad):
					if !lock:
						lock = true
					see.oper()
				icheck = false
		elif event.button_index == 2 and event.is_pressed() and ("Walkie-talkie" in col_item):
			ping()
	elif event.is_action_pressed("flash") and !lock and ("Flashlight" in col_item):
		flashtoggle()
	elif event.is_action_pressed("map") and ("Building Map" in col_item):
		if (!lock):
			lock = true
			checkmap()
		else:
			lock = false
	elif event.is_action_pressed("ui_cancel"):
		if !(Global.ui):
			dis_set()

func chmouse():
	lock = false
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func flashtoggle():
	flashlight_tog.play()
	if flash.light_energy > 0:
		flash.light_energy = 0
	else:
		flash.light_energy = flight_en
		
func seeitem():
	if (dot.modulate == Color("ffffff00")):
		var tween = get_tree().create_tween()
		tween.tween_property(dot, "modulate", Color("ffffffff"), 0.2)

func displayitem(pic, nam, des):
	var create = disitem.instantiate()
	
	add_child(create)
	
	create.setup(pic, nam, des)

func labeldisplay(txt):
	if (label.modulate == Color("ffffff00")):
		label.text = txt
		var tween = get_tree().create_tween()
		tween.tween_property(label, "modulate", Color("ffffffb9"), 0.2)
		if (txt == "Shift to run"):
			tween.tween_interval(2)
		tween.tween_interval(0.8)
		tween.tween_property(label, "modulate", Color("ffffff00"), 0.2)

func checkmap():
	map_look.play()
	var create = map.instantiate()
	add_child(create)

func blink():
	if !isblink:
		isblink = true
		var tween = get_tree().create_tween()
		tween.tween_property(flash, "light_energy", 0, 0.2)
		tween.tween_property(flash, "light_energy", 0.3, 0.2)
		tween.tween_interval(0.4)
		tween.set_parallel()
		tween.tween_property(flash, "light_energy", 0, 0.2)
		tween.tween_property(dark, "modulate", Color(0,0,0,1), 0.2)
		await tween.finished
		dead.emit()
		glitch_off()
		var tween2 = get_tree().create_tween()
		tween2.tween_interval(0.6)
		tween.set_parallel()
		tween2.tween_property(dark, "modulate", Color(0,0,0,0), 0.2)
		tween2.tween_property(flash, "light_energy", 0.3, 0.2)

		
		isblink = false

func ping(what="generic"):
	if (what == "generic"):
		what = Global.stor_what
	if (!Global.radio_playing) and ("Walkie-talkie" in col_item):
		sub(dialouge.play(what))
	if (what == "Junction"):
		Global.stor_what = "Storage"
func sub(des=""):
	if (des != ""):
		sub_la.text = des
		var tween = get_tree().create_tween()
		tween.tween_property(sub_la, "modulate", Color("f0f0f0f4"), 0.2)
		

func glitch_off():
	glitch_1.stop_fade(glitch.modulate.a + 1)
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(glitch, "modulate", Color("ffffff00"), glitch.modulate.a + 1)
	tween.tween_property(self, "speed", og_sp, 1)
	await tween.finished
	nono_counter = 0
	old_nono = 0
	Global.time_nono = 0
	glitch.visible = false
	if (Global.gen_on):
		sprint_e = true

func darknow():
	var tween = get_tree().create_tween()
	tween.tween_property(dark, "modulate", Color(0,0,0,1), 0.2)
	tween.tween_interval(0.5)
	tween.tween_property(dark, "modulate", Color(0,0,0,0), 0.2)
	
func playfootstep(velo, sp):
	if (velo.x == 0) and (velo.z == 0):
		footstepw.pause_fade(0.5)
		footstepr.pause_fade(0.5)
	elif (sp == speed):
		footstepw.stream_paused = false
		footstepr.pause_fade(0.2)
	elif (sp == max):
		footstepr.stream_paused = false
		footstepw.pause_fade(0.2)
	

func win():
	if (white.modulate.a == 0):
		var tween = create_tween()
		tween.tween_property(white, "modulate", Color(1,1,1,1), 1)
		await tween.finished
		windoor.play()
		Global.stor_what = "End"
		ping(Global.stor_what)


func _on_dialouge_radio_done() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(sub_la, "modulate", Color("ffffff00"), 0.2)
	print(Global.stor_what, Global.kit_com, Global.radio_playing)
	if (Global.stor_what == "Research") and Global.kit_com:
		Global.stor_what = "Extend"
		await get_tree().create_timer(0.5).timeout
		Global.radio_playing = false
		ping(Global.stor_what)
	if (Global.stor_what == "End"):
		await get_tree().create_timer(0.5).timeout
		var create = end.instantiate()
		add_child(create)

func radio_fstop():
	_on_dialouge_radio_done()
	dialouge.fstop()

func dis_set():
	var creaete = setting.instantiate()
	add_child(creaete)
