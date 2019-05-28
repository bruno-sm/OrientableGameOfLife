extends VBoxContainer

# class member variables go here, for example:
var current = "torus"
var state = 1
onready var node = get_node("TorusOption")

var torus_opt = preload("res://torus_opt.png")
var torus_opt1 = preload("res://torus_opt1.png")
var torus_opt2 = preload("res://torus_opt2.png")
var sphere_opt = preload("res://sphere_opt.png")
var sphere_opt1 = preload("res://sphere_opt1.png")
var sphere_opt2 = preload("res://sphere_opt2.png")

var time = 0
var tick = 0.3

func _ready():
	set_process(true)

func _process(delta):
	time += delta
	if time >= tick:
		time -= tick
		if current == "torus" and state == 1:
			node.set_texture(torus_opt2)
			state = 2
		elif current == "torus" and state == 2:
			node.set_texture(torus_opt1)
			state = 1
		elif current == "sphere" and state == 1:
			node.set_texture(sphere_opt2)
			state = 2
		elif current == "sphere" and state == 2:
			node.set_texture(sphere_opt1)
			state = 1
		update()

func _input(event):
	if event is InputEventKey and event.is_pressed() and (event.scancode == KEY_UP or event.scancode == KEY_DOWN):
		if current == "torus":
			node.set_texture(torus_opt)
			current = "sphere"
			node = get_node("SphereOption")
			node.set_texture(sphere_opt1)
		else:
			node.set_texture(sphere_opt)
			current = "torus"
			node = get_node("TorusOption")
			node.set_texture(torus_opt1)
	elif event is InputEventKey and event.is_pressed() and event.scancode == KEY_ENTER:
		if current == "torus":
			get_tree().change_scene("res://torus.tscn")
		elif current == "sphere":
			get_tree().change_scene("res://sphere.tscn")
			