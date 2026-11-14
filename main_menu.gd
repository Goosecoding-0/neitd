extends Control

func _ready() -> void:
	$TextureRect/VBoxContainer/Button.pressed.connect(_on_play_pressed)
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://night_shifts.tscn")
	
