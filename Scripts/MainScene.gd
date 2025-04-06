extends Node

func _ready() -> void:
	if OS.get_name() == "Windows" || OS.get_name() == "Linux":
		get_window().size *= 2
		#get_window().move_to_center()
	$File.init("game folder", true)
