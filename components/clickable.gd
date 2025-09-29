class_name Clickable extends Node


@export var area: Area2D

signal left_click
signal right_click


func _ready() -> void:
	pass
	area.input_event.connect(_on_input_event)

func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("mouse_left"):
		left_click.emit()
	if Input.is_action_just_pressed("mouse_right"):
		right_click.emit()
