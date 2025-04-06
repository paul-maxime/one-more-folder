extends Node2D

var is_folder = false

func init(filename: String, folder: bool) -> void:
	is_folder = folder
	$VBoxContainer/Filename.text = filename
	was_deselected()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.double_click:
			$"../WindowsManager".open_window()
		elif event.pressed:
			$"../WindowsManager".select_file(self)

func was_selected() -> void:
	if is_folder:
		$VBoxContainer/Icon.texture = load("res://Assets/folder-focus.png")
	else:
		$VBoxContainer/Icon.texture = load("res://Assets/file-focus.png")

func was_deselected() -> void:
	if is_folder:
		$VBoxContainer/Icon.texture = load("res://Assets/folder.png")
	else:
		$VBoxContainer/Icon.texture = load("res://Assets/file.png")
