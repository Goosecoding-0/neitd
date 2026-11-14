extends CharacterBody3D

@export var speed: float = 2.5
var is_active: bool = true

# Ищем цель с именем "player" в сцене
@onready var target: Node3D = get_tree().current_scene.find_child("player", true, false)

func _physics_process(delta: float) -> void:
	if not is_active or not target:
		return
		
	# Идем прямо к игроку (узлу player)
	var target_pos = target.global_position
	var direction = global_position.direction_to(target_pos)
	direction.y = 0 # Держимся на уровне пола
	
	velocity = direction * speed
	move_and_slide()
	
	# Поворачиваем робота лицом к игроку
	if global_position.distance_to(target_pos) > 0.5:
		look_at(Vector3(target_pos.x, global_position.y, target_pos.z), Vector3.UP)
	
	# Если добежал ближе чем на 2 метра — запускаем скример
	if global_position.distance_to(target_pos) < 2.0:
		trigger_jumpscare()

func trigger_jumpscare() -> void:
	is_active = false
	var jumpscare_ui = get_tree().current_scene.find_child("JumpscareUI", true, false)
	if jumpscare_ui:
		jumpscare_ui.show()
		# Запускаем логику видео в UI
		if jumpscare_ui.has_method("start_jumpscare"):
			jumpscare_ui.start_jumpscare()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		get_tree().reload_current_scene()
