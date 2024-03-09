class_name FreeFlyCam
extends Node3D

@export var lock_cam_key : InputEventKey

@export var enable_movement : bool = true


var cam_locked : bool = false

var mouse_active : bool = false : set = _set_mouse_active
func _set_mouse_active(val):
	if val == true:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	mouse_active = val

@export var fly_speed : float = 20.0
var turn_speed : float = 0.005

var cam : Camera3D

func _enter_tree():
	var c = Camera3D.new()
	c.current = true
	add_child(c)
	cam = c

func _ready():
	cam_locked = true
	mouse_active = true

func _input(event):
	if !cam_locked:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * turn_speed)
			cam.rotate_x(-event.relative.y * turn_speed)
			cam.rotation.x = clampf(cam.rotation.x, -deg_to_rad(80), deg_to_rad(80))
	
	if event is InputEventKey and event.is_pressed():
		if event.keycode == lock_cam_key.keycode:
			cam_locked = !cam_locked
			mouse_active = !mouse_active

func get_input() -> Vector2:
	#CHANGE THESE STRINGS TO SET CUSTOM KEYS
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func _physics_process(delta):
	if enable_movement:
		var move_dir = get_input()
		var forward = cam.global_transform.basis * Vector3(move_dir.x,0,move_dir.y)
		var dir = Vector3(forward.x, forward.y, forward.z).normalized()
		
		position += (dir * fly_speed) * delta
