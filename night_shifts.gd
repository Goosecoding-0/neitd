extends Control

# Переменная для хранения текущей открытой ночи
var current_night: int = 1

func _ready() -> void:
	# При открытии меню сразу загружаем сохраненную ночь из файла
	load_game()
	
	# Настраиваем все 7 ночей
	setup_night($night1, 1)
	setup_night($night2, 2)
	setup_night($night3, 3)
	setup_night($night4, 4)
	setup_night($night5, 5)
	setup_night($night6, 6)
	setup_night($night7, 7)

# Функция загрузки сохранения прямо здесь
func load_game() -> void:
	if FileAccess.file_exists("user://savegame.save"):
		var file = FileAccess.open("user://savegame.save", FileAccess.READ)
		var data = file.get_var()
		if data is Dictionary and data.has("current_night"):
			current_night = data["current_night"]

# Функция сохранения прогресса прямо здесь
func save_game() -> void:
	var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var data = { "current_night": current_night }
	file.store_var(data)

func setup_night(night_node: Control, night_num: int) -> void:
	if night_node.has_node("ClickBtn"):
		var btn = night_node.get_node("ClickBtn")
		
		# Если номер ночи меньше или равен текущей — она открыта
		if night_num <= current_night:
			btn.disabled = false
			night_node.modulate = Color(1, 1, 1, 1) # Яркая
			
			if not btn.pressed.is_connected(_on_night_selected.bind(night_num)):
				btn.pressed.connect(_on_night_selected.bind(night_num))
		else:
			btn.disabled = true
			night_node.modulate = Color(0.4, 0.4, 0.4, 1) # Затемненная (заблокирована)

func _on_night_selected(night_num: int) -> void:
	current_night = night_num
	save_game() # Сохраняем выбор
	
	# Переключаемся на нужную сцену уровня
	match night_num:
		1:
			get_tree().change_scene_to_file("res://node_3d.tscn")
		2:
			get_tree().change_scene_to_file("res://node_3d_2.tscn")
		3:
			get_tree().change_scene_to_file("res://node_3d_3.tscn")
		4:
			get_tree().change_scene_to_file("res://node_3d_4.tscn")
		5:
			get_tree().change_scene_to_file("res://node_3d_5.tscn")
		6:
			get_tree().change_scene_to_file("res://node_3d_6.tscn")
		7:
			get_tree().change_scene_to_file("res://node_3d_7.tscn")
		_:
			get_tree().change_scene_to_file("res://node_3d.tscn")
