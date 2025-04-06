extends Node

func _ready() -> void:
	get_window().content_scale_size = get_window().size / 2
	$File.init("game folder", true)
