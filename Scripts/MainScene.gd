extends Node

var victory_scene = preload("res://Scenes/VictoryScreen.tscn")

func _ready() -> void:
	if OS.get_name() == "Windows" || OS.get_name() == "Linux":
		get_window().size *= 2
		get_window().move_to_center()
	$File.init("game folder", true)

func open_file(filename: String) -> void:
	filename = filename.replace("\n", " ")
	if filename == "game folder":
		var window = $WindowsManager.create_window(filename)
		window.create_file("un fichier")
		window.create_file("un fichier")
		window.create_file("un fichier")
		window.goto_next_line()
		window.create_file("un fichier")
		window.create_file("un fichier plus long")
		window.create_file("un fichier")
		window.goto_next_line()
		window.create_file("un fichier")
		window.goto_next_line()
		window.create_file("un fichier")
		window.create_folder("un super\ndossier")
		window.finalize_window()
		$WindowsManager.open_window(window)
	elif filename == "un super dossier":
		var window = $WindowsManager.create_window(filename)
		window.create_file("data")
		window.create_folder("empty")
		window.create_file("thing")
		window.finalize_window()
		$WindowsManager.open_window(window)
	elif filename == "empty":
		var window = $WindowsManager.create_window(filename)
		window.finalize_window()
		$WindowsManager.open_window(window)
	elif filename == "data":
		add_child(victory_scene.instantiate())
		$OpenSoundPlayer.play()
	else:
		$CannotOpenSoundPlayer.play()
		$WindowsManager.unselect_current_file()
