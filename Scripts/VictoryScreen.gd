extends Node

var is_loading = false
var is_playing = false
var elapsed_time: float = 0
var progress_count: int = 0

func _ready() -> void:
	$ColorRect.size = get_viewport().get_visible_rect().end
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "color", Color(0.1, 0.1, 0.3, 1), 0.5)
	tween.tween_callback(after_tween)

func after_tween() -> void:
	is_loading = true
	$CanvasLayer.show()

func _process(delta: float) -> void:
	if is_loading:
		elapsed_time += delta
		if elapsed_time > 0.3:
			elapsed_time -= 0.3
			progress_count += 1
			var text: String = $CanvasLayer/CenterContainer/VBoxContainer/LoadingProgress.text
			text = "■" + text.substr(0, text.length() - 1)
			$CanvasLayer/CenterContainer/VBoxContainer/LoadingProgress.text = text
			if progress_count == 10:
				congratz()

func congratz() -> void:
	is_loading = false
	is_playing = true
	$CanvasLayer/CenterContainer.mouse_default_cursor_shape = Input.CURSOR_CROSS
	$MovingFilesSpawner.show()
	$CanvasLayer/CenterContainer/VBoxContainer/LoadingProgress.hide()
	$CanvasLayer/CenterContainer/VBoxContainer/LoadingLabel.text = "Congratulations!\nYou managed to start the game."

func _input(event: InputEvent) -> void:
	if !is_playing:
		return
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
			if get_viewport().get_visible_rect().has_point(event.position):
				$ShotSoundPlayer.play()
