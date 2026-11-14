extends Control

# Ищем камеры по всей главной сцене
@onready var cam_1: Camera3D = get_tree().current_scene.find_child("CAM1", true, false)
@onready var cam_2: Camera3D = get_tree().current_scene.find_child("CAM2", true, false)
@onready var cam_3: Camera3D = get_tree().current_scene.find_child("CAM3", true, false)
@onready var player_cam: Camera3D = _get_player_camera()

@onready var line_edit: LineEdit = find_child("LineEdit", true, false)
@onready var output_label: Label = find_child("OutputLabel", true, false)

# Функция для поиска камеры игрока внутри узла Player
func _get_player_camera() -> Camera3D:
	var main_scene = get_tree().current_scene
	if main_scene:
		var player = main_scene.find_child("Player", true, false)
		if player:
			return player.find_child("Camera3D", true, false)
	return null

func _ready() -> void:
	if line_edit:
		line_edit.text_submitted.connect(_on_text_submitted)
	
	if output_label:
		output_label.text = "SYS_INIT OK.\nType '#help' for commands."

func _on_text_submitted(text: String) -> void:
	text = text.strip_edges().to_lower()
	var response = ""
	
	match text:
		"cam1", "#cam1":
			if cam_1:
				cam_1.make_current()
				response = ">> [OK] CAM_01 ACTIVE."
			else:
				response = ">> [ERROR] CAM_01 not found!"
				
		"cam2", "#cam2":
			if cam_2:
				cam_2.make_current()
				response = ">> [OK] CAM_02 ACTIVE."
			else:
				response = ">> [ERROR] CAM_02 not found!"
				
		"cam3", "#cam3":
			if cam_3:
				cam_3.make_current()
				response = ">> [OK] CAM_03 ACTIVE."
			else:
				response = ">> [ERROR] CAM_3 not found! Убедись, что камера названа CAM3."
				
		"task1", "task one", "#task1":
			response = ">> TASK 1: Check the generator stability. Type: #power"
			
		"#power":
			response = ">> POWER: 87%. Sector 4 risk! Type: #reboot sector4"
			
		"#reboot sector4":
			response = ">> SECTOR 4 REBOOTED. Task 1 complete!"
			
		"task2", "task two", "#task2":
			response = ">> TASK 2: Firewall breach. Type: #override 4048"
			
		"#override 4048":
			response = ">> FIREWALL OVERRIDDEN. Task 2 complete!"
			
		"help", "#help":
			response = ">> COMMANDS:\n- cam1 / cam2 / cam3\n- task1 / task2\n- #exit (Close terminal)\n\n[TIP]: Если не можете писать, нажмите ESC или наведите мышкой и кликните в поле ввода!"
			
		"exit", "#exit":
			if player_cam:
				player_cam.make_current()
			hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			response = ">> TERMINAL DISCONNECTED."
			
		_:
			response = ">> UNKNOWN COMMAND. Type #help"
			
	if output_label:
		output_label.text = response
		
	line_edit.clear()
	if line_edit:
		line_edit.grab_focus()
