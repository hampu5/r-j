extends ColorRect


var rotate_tween: Tween
var rotation_velocity: float


func _ready() -> void:
	show()
	rotation = PI * randf()
	rotation_velocity = -0.01 if randf() > 0.5 else 0.01

func _physics_process(delta: float) -> void:
	if randf() > 0.99:
		if rotate_tween:
			rotate_tween.kill()
		rotate_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		rotate_tween.tween_property(self, "rotation_velocity", -0.01 if randf() > 0.5 else 0.01, 2)
	rotation += delta * rotation_velocity
