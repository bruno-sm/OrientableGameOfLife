extends Viewport

onready var main_view = get_node("/root/MarginContainer/Camera2D/CenterContainer/MainContainer/MainViewport")

func _ready():
	self.world_2d = main_view.world_2d