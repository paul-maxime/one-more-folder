extends Node

var window_scene = preload("res://Scenes/Window.tscn")
var windows = []
var selected_file: Node2D = null

func _unhandled_input(event) -> void:
	if event is InputEventKey:
		if !event.pressed && event.physical_keycode == KEY_ESCAPE:
			if windows.size() > 0:
				close_window(windows[0])
	if event is InputEventMouseButton:
		for window: Node2D in windows:
			if window.handle_mouse_button(event):
				break
	elif event is InputEventMouseMotion:
		for window: Node2D in windows:
			if window.handle_mouse_motion(event):
				break

func open_window() -> void:
	$"../OpenSoundPlayer".play()
	var window: Node2D = window_scene.instantiate()
	window.set_title("Super fenêtre")
	add_child(window)
	window.position = floor(get_viewport().get_mouse_position() - window.size_in_pixels / 2)
	window.clamp_position()
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
	$"../CloseSoundPlayer".play()
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
