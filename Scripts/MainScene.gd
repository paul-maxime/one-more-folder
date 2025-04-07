extends Node

var victory_scene = preload("res://Scenes/VictoryScreen.tscn")

func _ready() -> void:
	if OS.get_name() == "Windows" || OS.get_name() == "Linux":
		get_window().size *= 2
		get_window().move_to_center()
	$GameFolder.init("game folder", true)
	$SystemFolder.init("system folder", true)

func open_file(filename: String) -> void:
	filename = filename.replace("\n", " ")
	if filename == "game folder":
		var window = $WindowsManager.create_window(filename)
		window.create_file("how to play.txt")
		window.create_folder("binaries")
		window.create_folder("manual")
		$WindowsManager.open_window(window)
	elif filename == "how to play.txt":
		var window = $WindowsManager.create_window(filename)
		window.display_text("Thanks for downloading our game!\nTo play, just run the executable in BINARIES.\n\nIf you don't know which architecture you\nare using, refer to the manual.")
		$WindowsManager.open_window(window)
	elif filename == "binaries":
		var window = $WindowsManager.create_window(filename)
		window.create_folder("arch_x17")
		window.create_folder("arch_x24")
		window.create_folder("arch_x33")
		window.create_folder("arch_x38")
		window.create_folder("arch_x44")
		window.goto_next_line()
		window.create_folder("arch_x48")
		window.create_folder("arch_x65")
		window.create_folder("arch_x77")
		window.create_folder("arch_x88")
		window.create_folder("arch_x97")
		$WindowsManager.open_window(window)
	elif filename.begins_with("arch_x") && !filename.contains("_v"):
		var window = $WindowsManager.create_window(filename)
		window.create_folder(filename + "_v1")
		window.create_folder(filename + "_v2")
		window.create_folder(filename + "_v3")
		window.goto_next_line()
		window.create_folder(filename + "_v4")
		window.create_folder(filename + "_v5")
		window.create_folder(filename + "_v6")
		$WindowsManager.open_window(window)
	elif filename.begins_with("arch_x") && filename.contains("_v"):
		var window = $WindowsManager.create_window(filename)
		window.create_file("game_" + filename.replace("arch_", "") + ".exe")
		window.create_folder("tools_" + filename.replace("arch_", ""))
		$WindowsManager.open_window(window)
	elif filename == "game_x38_v5.exe":
		add_child(victory_scene.instantiate())
		$OpenSoundPlayer.play()
	elif filename.begins_with("game_") && filename.ends_with(".exe"):
		var window = $WindowsManager.create_window(filename)
		window.display_error("error: invalid architecture")
		$WindowsManager.open_window(window)
	elif filename == "manual":
		var window = $WindowsManager.create_window(filename)
		window.create_file("architectures.txt")
		$WindowsManager.open_window(window)
	elif filename == "architectures.txt":
		var window = $WindowsManager.create_window(filename)
		window.display_text("Unsure which architecture folder you are using?\nDon't worry!\n\nYou can easily check your current architecture\nby reading the ARCH.INI file in your system folder.")
		$WindowsManager.open_window(window)
	elif filename == "system folder":
		var window = $WindowsManager.create_window(filename)
		window.create_folder("sys")
		window.create_file("arch.ini")
		$WindowsManager.open_window(window)
	elif filename == "arch.ini":
		var window = $WindowsManager.create_window(filename)
		window.display_text("; this file has been deprecated\n; please check the SYS folder instead")
		$WindowsManager.open_window(window)
	elif filename == "sys":
		var window = $WindowsManager.create_window(filename)
		window.create_file("current-arch.ini")
		$WindowsManager.open_window(window)
	elif filename == "current-arch.ini":
		var window = $WindowsManager.create_window(filename)
		window.display_text("[arch]\ncurrent_arch = arch_x38_v5")
		$WindowsManager.open_window(window)
	else:
		$CannotOpenSoundPlayer.play()
		$WindowsManager.unselect_current_file()
