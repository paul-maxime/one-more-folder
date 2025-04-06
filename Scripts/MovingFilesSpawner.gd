extends Node2D

var moving_file_scene = preload("res://Scenes/VictoryMovingFile.tscn")

var next_spawn_in: float = 1.0

func _process(delta: float) -> void:
    if !visible: return
    next_spawn_in -= delta
    if next_spawn_in < 0:
        next_spawn_in += 1.0
        add_child(moving_file_scene.instantiate())
