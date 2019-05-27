extends Node2D

var grid = []
var aux_grid = []
var n = 60
var time = 0
var tick = 0.000001
var back_color = Color("#f4f4f4")
var cell_color = Color("#4e4e4e")
var lines_color = Color("#bfbfbf")
var border_color = Color("#4e4e4e")
var stop = true


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
	draw_line(Vector2(0, 0), Vector2(0, n*10), border_color, 3)
	draw_line(Vector2(0, 0), Vector2(n*10, 0), border_color, 3)
	draw_line(Vector2(n*10, 0), Vector2(n*10, n*10), border_color, 3)
	draw_line(Vector2(0, n*10), Vector2(n*10, n*10), border_color, 3)


var mouse_pressed = false
var write_value = 1
func _input(event):
	if event is InputEventMouseButton:
		mouse_pressed = not mouse_pressed
		var x = int(floor(event.position.x)/10) % n
		var y = int(floor(event.position.y)/10) % n
		write_value = 1
		if grid[x][y] == 1:
			write_value = 0
		if mouse_pressed:
			grid[x][y] = write_value
		
	elif event is InputEventMouseMotion and mouse_pressed:
		var x = int(floor(event.position.x)/10) % n
		var y = int(floor(event.position.y)/10) % n
		grid[x][y] = write_value
		
	elif event is InputEventKey and event.is_pressed() and event.scancode == KEY_SPACE:
		stop = not stop
	
	# Print the size of the viewport
	# print("Viewport Resolution is: ", get_viewport_rect().size)