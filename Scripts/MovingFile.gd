extends Sprite2D

var speed = 1.0
var floating_position: Vector2

var is_destroying = false

func _ready() -> void:
	var is_folder = randi() % 2 == 1
	if is_folder:
		texture = load("res://Assets/folder.png");
	var from_left_side: bool = randi() % 2 == 1
	speed = randf_range(100.0, 250.0)
	position.y = randi_range(16, int(get_viewport_rect().end.y) - 16)
	if from_left_side:
		position.x = -32
	else:
		position.x = get_viewport_rect().end.x + 32
		speed *= -1
	floating_position = position

func _process(delta: float) -> void:
	if !is_destroying:
		floating_position.x += delta * speed
		if floating_position.x > get_viewport_rect().end.x + 64:
			queue_free()
		elif floating_position.x < -64:
			queue_free()
		position = Vector2i(floating_position)
	else:
		rotation += delta * 5.0
		scale.x -= delta * 1.0
		scale.y -= delta * 1.0
		if scale.x <= 0:
			queue_free()

func _input(event: InputEvent) -> void:
	if is_destroying:
		return
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
			if get_rect().has_point(to_local(event.position)):
				is_destroying = true
				$"/root/MainScene/VictoryScreen/DestroyedSoundPlayer".play()
