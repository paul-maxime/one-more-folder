extends Node

var window_scene = preload("res://Scenes/Window.tscn")
var windows = []

func _ready() -> void:
	var window: Node2D = window_scene.instantiate()
	window.init(self, 12, 8)
	window.set_title("Super fenêtre")
	add_child(window)
	var window2: Node2D = window_scene.instantiate()
	window2.init(self, 10, 8)
	window2.set_title("La fenêtre 2")
	window2.position = Vector2(62, 14)
	add_child(window2)
	var window3: Node2D = window_scene.instantiate()
	window3.init(self, 14, 8)
	window3.set_title("La fameuse et dernière 3e window")
	window3.position = Vector2(32, 54)
	add_child(window3)
	windows.append(window3)
	windows.append(window2)
	windows.append(window)
	update_z_indexes()

func _input(event) -> void:
	if event is InputEventMouseButton:
		for window: Node2D in windows:
			if window.handle_mouse_button(event):
				break
	elif event is InputEventMouseMotion:
		for window: Node2D in windows:
			if window.handle_mouse_motion(event):
				break

func focus_window(window: Node2D) -> void:
	if windows[0] == window:
		return
	var index = windows.find(window)
	windows.remove_at(index)
	windows.push_front(window)
	update_z_indexes()

func update_z_indexes() -> void:
	var z_index = windows.size() * 10
	for window: Node2D in windows:
		window.z_index = z_index
		z_index -= 10
