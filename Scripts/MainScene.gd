extends Node

var victory_scene = preload("res://Scenes/VictoryScreen.tscn")

var is_sudo = false
var driver_installed = false

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
		open_text_window(
			filename, "Thanks for downloading our game!\nTo play, just run the executable in BINARIES.\n\nIf you don't know which architecture you\nare using, refer to the manual.")
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
		if is_sudo:
			open_error_window(filename, "error: you are an administrator.")
		elif !driver_installed:
			open_error_window(filename, "error: gpu driver not installed.")
		elif $WindowsManager.windows.size() > 1:
			open_error_window(filename, "error: out of memory.\nplease close some windows.")
		else:
			open_victory_game()
	elif filename.begins_with("game_") && filename.ends_with(".exe"):
		if is_sudo:
			open_error_window(filename, "error: you are an administrator.")
		elif $WindowsManager.windows.size() > 1:
			open_error_window(filename, "error: out of memory.\nplease close some windows.")
		else:
			open_error_window(filename, "error: invalid architecture.\nplease check your architecture and try again.")
	elif filename.begins_with("tools_"):
		var window = $WindowsManager.create_window(filename)
		window.create_folder(filename.replace("tools_", "drivers_"))
		$WindowsManager.open_window(window)
	elif filename.begins_with("drivers_"):
		var window = $WindowsManager.create_window(filename)
		window.create_folder(filename.replace("drivers_", "astone "))
		window.create_folder(filename.replace("drivers_", "graveon "))
		window.goto_next_line()
		window.create_folder(filename.replace("drivers_", "puntel "))
		window.create_folder(filename.replace("drivers_", "zvidia "))
		$WindowsManager.open_window(window)
	elif (filename.begins_with("astone ") || filename.begins_with("graveon ") || filename.begins_with("puntel ") || filename.begins_with("zvidia ")) && filename.count(" ") == 1:
		var window = $WindowsManager.create_window(filename)
		window.create_folder(filename + " 321")
		window.create_folder(filename + " 407")
		window.create_folder(filename + " 999")
		window.goto_next_line()
		window.create_folder(filename + " 3006")
		window.create_folder(filename + " 9477")
		window.goto_next_line()
		window.create_folder(filename + " 19477 EXTRA")
		$WindowsManager.open_window(window)
	elif filename.begins_with("astone ") || filename.begins_with("graveon ") || filename.begins_with("puntel ") || filename.begins_with("zvidia "):
		var window = $WindowsManager.create_window(filename)
		window.create_file(filename.replace(" ", "_") + ".drv")
		window.create_file(filename.replace(" ", "_") + ".dat")
		$WindowsManager.open_window(window)
	elif filename == "graveon_x38_v5_3006.drv":
		if driver_installed:
			open_error_window(filename, "GPU drivers already installed.")
		elif !is_sudo:
			open_error_window(filename, "error: permission denied.\nyou are not an administrator.")
		else:
			open_success_window(filename, "GPU drivers installed successfully.")
			driver_installed = true
	elif filename.ends_with(".drv") && filename.contains("x38_v5") && filename.contains("puntel") && filename.contains("_9477"):
		open_error_window(filename, "error: cpu drivers already installed.")
	elif filename.ends_with(".drv") && filename.contains("x38_v5") && filename.contains("puntel"):
		open_error_window(filename, "error: could not detect the cpu.\nmake sure you are installing the correct drivers.")
	elif filename.ends_with(".drv") && filename.contains("x38_v5"):
		open_error_window(filename, "error: could not detect the gpu.\nmake sure you are installing the correct drivers.")
	elif filename.ends_with(".drv") && !filename.contains("x38_v5"):
		open_error_window(filename, "error: invalid architecture.\nplease check your architecture and try again.")
	elif filename == "manual":
		var window = $WindowsManager.create_window(filename)
		window.create_file("architectures.txt")
		window.create_file("admin and sudo.txt")
		window.create_file("drivers.txt")
		$WindowsManager.open_window(window)
	elif filename == "architectures.txt":
		open_text_window(filename, "Unsure which architecture you are using?\nDon't worry!\n\nYou can easily check your current architecture\nby reading the ARCH.INI file in your system folder.")
	elif filename == "admin and sudo.txt":
		open_text_window(filename, "To run the game, you must be a normal user.\nThe game will not run if you are an administrator.\n\nUse SUDO-DISABLE.EXE in the BIN folder to\nrevoke your administrator privileges.")
	elif filename == "drivers.txt":
		open_text_window(filename, "This game requires up to date drivers.\nMake sure to install the ones you need\nfrom the TOOLS folder.\n\nCheck the PROC system folder for more\ndetails about your system.")
	elif filename == "system folder":
		var window = $WindowsManager.create_window(filename)
		window.create_folder("bin")
		window.create_folder("proc")
		window.create_folder("sys")
		window.goto_next_line()
		window.create_file("arch.ini")
		$WindowsManager.open_window(window)
	elif filename == "arch.ini":
		open_text_window(filename, "; this file has been deprecated\n; please check the SYS folder instead")
	elif filename == "bin":
		var window = $WindowsManager.create_window(filename)
		window.create_folder("admin")
		window.create_folder("web")
		$WindowsManager.open_window(window)
	elif filename == "proc":
		var window = $WindowsManager.create_window(filename)
		window.create_folder("cpu")
		window.create_folder("gpu")
		window.create_folder("mem")
		$WindowsManager.open_window(window)
	elif filename == "sudo-enable.exe":
		if is_sudo:
			open_error_window(filename, "You are already an administrator.");
		else:
			is_sudo = true
			open_success_window(filename, "You are now an administrator.");
	elif filename == "sudo-disable.exe":
		if !is_sudo:
			open_error_window(filename, "You are already a normal user.");
		else:
			is_sudo = false
			open_success_window(filename, "You are now a normal user.");
	elif filename == "sys":
		var window = $WindowsManager.create_window(filename)
		if is_sudo:
			window.create_file("current-arch.ini")
		else:
			window.display_error("error: permission denied.\nyou are not an administrator.")
		$WindowsManager.open_window(window)
	elif filename == "current-arch.ini":
		open_text_window(filename, "[arch]\ncurrent_arch = arch_x38_v5")
	elif filename == "cpu":
		var window = $WindowsManager.create_window(filename)
		window.create_file("cpu-info.ini")
		window.create_file("cpu-data")
		$WindowsManager.open_window(window)
	elif filename == "gpu":
		var window = $WindowsManager.create_window(filename)
		window.create_file("gpu-info.ini")
		window.create_file("gpu-data")
		$WindowsManager.open_window(window)
	elif filename == "mem":
		var window = $WindowsManager.create_window(filename)
		window.create_file("realtime-data.ini")
		$WindowsManager.open_window(window)
	elif filename == "realtime-data.ini":
		open_text_window(filename, "[mem]\ntype = ZDDR 7.5\nfullname = ZDDR 7.5 Edition, x38 compatible\nusage = " + str($WindowsManager.windows.size() * 10) + " KiB")
	elif filename == "admin":
		var window = $WindowsManager.create_window(filename)
		window.create_file("sudo-enable.exe")
		window.create_file("sudo-disable.exe")
		$WindowsManager.open_window(window)
	elif filename == "web":
		var window = $WindowsManager.create_window(filename)
		$WindowsManager.open_window(window)
	elif filename == "cpu-info.ini":
		open_text_window(filename, "[cpu]\nspeed = 321 Hz\ncores = 3\nname = Puntel x38-9477")
	elif filename == "gpu-info.ini":
		open_text_window(filename, "[gpu]\nid = 47773006\nname = Graveon 3006 SUPER")
	else:
		$CannotOpenSoundPlayer.play()
		$WindowsManager.unselect_current_file()

func open_text_window(title: String, text: String):
	var window = $WindowsManager.create_window(title)
	window.display_text(text)
	$WindowsManager.open_window(window)

func open_success_window(title: String, text: String):
	var window = $WindowsManager.create_window(title)
	window.display_success(text)
	$WindowsManager.open_window(window)

func open_error_window(title: String, text: String):
	var window = $WindowsManager.create_window(title)
	window.display_error(text)
	$WindowsManager.open_window(window)

func open_victory_game():
	add_child(victory_scene.instantiate())
	$OpenSoundPlayer.play()
