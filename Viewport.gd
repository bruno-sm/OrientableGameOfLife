extends Viewport

onready var main_view = get_node("../../MainContainer/MainViewport")

func _ready():
	self.world_2d = main_view.world_2d
