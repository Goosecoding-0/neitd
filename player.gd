extends CharacterBody3D

@export var mouse_sensitivity: float = 0.003
@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	# Захватываем курсор мыши в центр экрана при запуске
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	# Если двигаем мышкой
	if event is InputEventMouseMotion:
		# Поворачиваем всего игрока влево-вправо по оси Y
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Поворачиваем камеру вверх-вниз по оси X
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		
		# Ограничиваем угол обзора по вертикали, чтобы голову не выворачивало наизнанку
		camera.rotation.x = clamp(camera.rotation.x, -1.2, 1.2)

func _input(event: InputEvent) -> void:
	# По нажатию клавиши Esc можно освободить курсор мыши (для удобства отладки)
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
