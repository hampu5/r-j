class_name MyButton extends TextureButton


static var button_pressed_static: bool = false
var mouse_inside: bool = false

signal clicked


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _input(_event: InputEvent) -> void:
	if mouse_inside and Input.is_action_just_pressed("mouse_left"):
		_on_button_down()
	elif mouse_inside and Input.is_action_just_released("mouse_left"):
		_on_button_up()

func _on_button_down() -> void:
	button_pressed_static = true

func _on_button_up() -> void:
	button_pressed_static = false
	if mouse_inside:
		button_pressed = true
		clicked.emit()

func _on_mouse_entered() -> void:
	mouse_inside = true
	if button_pressed_static:
		button_pressed = true

func _on_mouse_exited() -> void:
	mouse_inside = false
	button_pressed = false
