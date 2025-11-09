extends Node2D
@onready var button: Button = $Button
@export var destination: String = "res://scenes/.tscn"

#changes scene to the destination scene when pressed
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(destination)
