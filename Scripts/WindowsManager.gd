extends Node

var window_scene = preload("res://Scenes/Window.tscn")
var windows = []
var selected_file: Node2D = null

func _ready() -> void:
	# var window: Node2D = window_scene.instantiate()
	# window.init(self, 12, 8)
	# window.set_title("Super fenêtre")
	# add_child(window)
	# var window2: Node2D = window_scene.instantiate()
	# window2.init(self, 10, 8)
	# window2.set_title("La fenêtre 2")
	# window2.position = Vector2(62, 14)
	# add_child(window2)
	# var window3: Node2D = window_scene.instantiate()
	# window3.init(self, 14, 8)
	# window3.set_title("La fameuse et dernière 3e window")
	# window3.position = Vector2(32, 54)
	# add_child(window3)
	# windows.append(window3)
	# windows.append(window2)
	# windows.append(window)
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

func open_window() -> void:
	var window: Node2D = window_scene.instantiate()
	window.init(self, 12, 8)
	window.set_title("Super fenêtre")
	window.position = Vector2(62, 14)
	add_child(window)
	windows.push_front(window)
	update_z_indexes()
	unselect_current_file()

func focus_window(window: Node2D) -> void:
	if windows[0] == window:
		return
	var index = windows.find(window)
	windows.remove_at(index)
	windows.push_front(window)
	update_z_indexes()
	unselect_current_file()

func update_z_indexes() -> void:
	var z_index = windows.size() * 10
	var index = windows.size() - 1
	for window: Node2D in windows:
		move_child(window, index)
		window.z_index = z_index
		index -= 1
		z_index -= 10

func close_window(window: Node2D) -> void:
	unselect_current_file()
	var index = windows.find(window)
	windows.remove_at(index)
	window.queue_free()

func select_file(file: Node2D) -> void:
	if selected_file == file:
		return
	unselect_current_file()
	selected_file = file
	file.was_selected()

func unselect_current_file() -> void:
	if selected_file != null:
		selected_file.was_deselected()
		selected_file = null
