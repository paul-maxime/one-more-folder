extends Node2D

var windows_manager: Node
var size_in_chunks: Vector2i
var size_in_pixels: Vector2
var is_dragging = false
var is_dragging_from: Vector2
var is_dragging_from_mouse_pos: Vector2
var pressed_close = false

func _ready() -> void:
	spawn_window_elements()

func init(manager: Node, size_x: int, size_y: int) -> void:
	windows_manager = manager
	size_in_chunks = Vector2i(size_x, size_y)
	size_in_pixels = Vector2(size_x * 16, size_y * 16)

func spawn_window_elements() -> void:
	var size_x = size_in_chunks.x
	var size_y = size_in_chunks.y
	$CloseButton.position = Vector2(size_x * 16 - 16, 0)
	$Background.size = Vector2(size_x * 16, size_y * 16)
	for x in range(size_x):
		for y in range(size_y):
			var texture = null
			if y == 0:
				# header
				if x == 0:
					texture = "header-left"
				elif x == size_x - 1:
					texture = "header-right"
				else:
					texture = "header-middle"
			elif y == 1:
				# top
				if x == 0:
					texture = "ui-top-left"
				elif x == size_x - 1:
					texture = "ui-top-right"
				else:
					texture = "ui-top"
			elif y == size_y - 1:
				# bottom
				if x == 0:
					texture = "ui-bottom-left"
				elif x == size_x - 1:
					texture = "ui-bottom-right"
				else:
					texture = "ui-bottom"
			else:
				# center
				if x == 0:
					texture = "ui-left"
				elif x == size_x - 1:
					texture = "ui-right"

			if texture != null:
				var sprite = Sprite2D.new()
				sprite.texture = load("res://Assets/" + texture + ".png")
				sprite.position = Vector2(x * 16, y * 16)
				sprite.centered = false
				sprite.z_index = -1
				add_child(sprite)

func handle_mouse_button(event: InputEventMouseButton) -> bool:
	if !is_position_part_of_window(event.position) && !is_dragging:
		return false
	if is_position_close_button(event.position):
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				pressed_close = true
				$CloseButton.texture = load("res://Assets/header-close-focus.png")
			elif pressed_close:
				pressed_close = false
				$CloseButton.texture = load("res://Assets/header-close.png")
				windows_manager.close_window(self)
				$Background.mouse_default_cursor_shape = Input.CURSOR_ARROW
			return true
	if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		windows_manager.focus_window(self)
		is_dragging_from = position
		is_dragging_from_mouse_pos = event.position
		is_dragging = true
		$Background.mouse_default_cursor_shape = Input.CURSOR_MOVE
		windows_manager.unselect_current_file()
	if event.button_index == MOUSE_BUTTON_LEFT && !event.pressed:
		is_dragging = false
		$Background.mouse_default_cursor_shape = Input.CURSOR_ARROW
	return true

func handle_mouse_motion(event: InputEventMouseMotion) -> bool:
	if !is_position_part_of_window(event.position) && !is_dragging && !pressed_close:
		return false
	if !is_dragging:
		if is_position_close_button(event.position):
			$Background.mouse_default_cursor_shape = Input.CURSOR_POINTING_HAND
		else:
			if pressed_close:
				pressed_close = false
				$CloseButton.texture = load("res://Assets/header-close.png")
			$Background.mouse_default_cursor_shape = Input.CURSOR_ARROW
	if is_dragging:
		position = floor(is_dragging_from + event.position - is_dragging_from_mouse_pos)
		clamp_position()
	return true

func clamp_position() -> void:
	if position.x < 0: position.x = 0
	if position.y < 0: position.y = 0
	if position.x + size_in_pixels.x >= get_viewport_rect().end.x: position.x = get_viewport_rect().end.x - size_in_pixels.x
	if position.y + size_in_pixels.y >= get_viewport_rect().end.y: position.y = get_viewport_rect().end.y - size_in_pixels.y

func is_position_part_of_window(event_position: Vector2) -> bool:
	return event_position.x >= position.x && \
		event_position.x <= position.x + size_in_pixels.x && \
		event_position.y >= position.y && \
		event_position.y <= position.y + size_in_pixels.y

func is_position_close_button(event_position: Vector2) -> bool:
	return event_position.x >= $CloseButton.global_position.x + 2 && \
		event_position.x <= $CloseButton.global_position.x + 13 && \
		event_position.y >= $CloseButton.global_position.y + 3 && \
		event_position.y <= $CloseButton.global_position.y + 14

func set_title(text: String) -> void:
	$WindowTitle.text = text
