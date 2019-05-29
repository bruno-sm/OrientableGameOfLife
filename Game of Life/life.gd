extends Node2D

var grid = []
var aux_grid = []
var n = 60
var time = 0
var tick = 0.1
var back_color = Color("#f4f4f4")
var cell_color = Color("#4e4e4e")
var lines_color = Color("#bfbfbf")
var border_color = Color("#4e4e4e")
var stop = true
var dialog = 0


func _ready():
	VisualServer.set_default_clear_color(back_color)
	for i in range(0, n, 1):
		grid.append([])
		aux_grid.append([])
		for j in range(0, n, 1):
			grid[i].append(0)
			aux_grid[i].append(0)
	grid[32][31] = 1
	grid[31][31] = 1
	grid[33][32] = 1
	grid[32][32] = 1
	grid[32][33] = 1
	set_process(true)


func _process(delta):
	time += delta
	if time >= tick:
		time -= tick
		update()
		if not stop:
			update_grid()


func update_grid():
	for i in range(0, n, 1):
		for j in range(0, n, 1):
			var s = grid[(i-1+n) % n][(j-1+n) % n]
			s += grid[i][(j-1+n) % n]
			s += grid[(i+1) % n][(j-1+n) % n]
			s += grid[(i-1+n) % n][j]
			s += grid[(i+1) % n][j]
			s += grid[(i-1+n) % n][(j+1) % n]
			s += grid[i][(j+1) % n]
			s += grid[(i+1) % n][(j+1) % n]
			if s == 3:
				aux_grid[i][j] = 1
			elif s == 2:
				aux_grid[i][j] = grid[i][j]
			else:
				aux_grid[i][j] = 0
				
	for i in range(0, n, 1):
		grid[i] = aux_grid[i].duplicate()


func _draw():
	# Draw cells ----------------------------------------------
	for i in range(0, n, 1):
		for j in range(0, n, 1):
			var color = back_color
			if grid[i][j] == 1:
				color = cell_color
			draw_rect(Rect2(i*10, j*10, 10, 10), color)
			
	# Draw grid lines -----------------------------------------
	for i in range(1, n, 1):
		draw_line(Vector2(i*10, 0), Vector2(i*10, n*10), lines_color, 2)
	for j in range(1, n, 1):
		draw_line(Vector2(0, j*10), Vector2(n*10, j*10), lines_color, 2)
	draw_line(Vector2(0, 0), Vector2(0, n*10), border_color, 4)
	draw_line(Vector2(0, 0), Vector2(n*10, 0), border_color, 4)
	draw_line(Vector2(n*10, 0), Vector2(n*10, n*10), border_color, 4)
	draw_line(Vector2(0, n*10), Vector2(n*10, n*10), border_color, 4)


var pressed = false
var write_value = 1
func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and dialog == 0:
		pressed = true
		var p = event.position
		var x = int(floor(p.x)/10) % n
		var y = int(floor(p.y)/10) % n
		if x >= 0 and x < n and y >=0 and y < n:
			write_value = 1
			if grid[x][y] == 1:
				write_value = 0
			grid[x][y] = write_value
			
	elif event is InputEventMouseButton and (not event.is_pressed()):
		pressed = false

	elif event is InputEventMouseMotion and pressed and dialog == 0:
		var p = event.position
		var x = int(floor(p.x)/10)
		var y = int(floor(p.y)/10)
		if x >= 0 and x < n and y >=0 and y < n:
			grid[x][y] = write_value
		
	elif event is InputEventKey and event.is_pressed() and event.scancode == KEY_SPACE:
		stop = not stop
	
	elif event is InputEventKey and event.is_pressed() and event.scancode == KEY_ESCAPE:
		get_tree().change_scene("res://MainMenu.tscn")
		
	elif event is InputEventKey and event.is_pressed() and event.scancode == KEY_O and event.get_control():
		get_node("/root/MarginContainer/OpenFileDialog").popup()
		
	elif event is InputEventKey and event.is_pressed() and event.scancode == KEY_S:
		get_node("/root/MarginContainer/SaveFileDialog").popup()
	# Print the size of the viewport
	# print("Viewport Resolution is: ", get_viewport_rect().size)

func _on_OpenFileDialog_file_selected(path):
	var f = File.new()
	f.open(path, 1)
	var content = f.get_as_text()
	f.close()
	content = content.strip_edges()
	var i = 0
	var j = 0
	for l in content.split("\n"):
		for c in l:
			if c == "0":
				print("cero")
				grid[i][j] = 0
			elif c == "x":
				grid[i][j] = 1
			j += 1
		i += 1
		j = 0
	update()


func _on_SaveFileDialog_file_selected(path):
	var f = File.new()
	f.open(path, 2)
	for l in grid:
		for x in l:
			if x == 0:
				f.store_string("0")
			else:
				f.store_string("x")
		f.store_string("\n")
	f.close()


func _on_OpenFileDialog_popup_hide():
	dialog -= 1


func _on_OpenFileDialog_about_to_show():
	dialog += 1


func _on_SaveFileDialog_popup_hide():
	dialog -= 1


func _on_SaveFileDialog_about_to_show():
	dialog += 1
