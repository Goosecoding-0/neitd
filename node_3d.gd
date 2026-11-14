extends Node3D

@onready var phone_audio: AudioStreamPlayer3D = find_child("PhoneAudio", true, false)
@onready var phone_ray: RayCast3D = find_child("PhoneRay", true, false)

# Ссылки на интерфейс компьютера и поле ввода текста
@onready var computer_ui: Control = find_child("ComputerUI", true, false)
@onready var line_edit: LineEdit = find_child("LineEdit", true, false)

func _ready() -> void:
	# Запускаем звонок Фонгая при старте игры
	if phone_audio and phone_audio.stream:
		phone_audio.play()
	
	# Скрываем интерфейс компьютера в начале ночи
	if computer_ui:
		computer_ui.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		if not phone_ray:
			print("Ошибка: узел PhoneRay не найден!")
			return
			
		if phone_ray.is_colliding():
			var collider = phone_ray.get_collider()
			if collider:
				
				# 1. Если смотрим на телефон — вырубаем звук звонка
				if "Phone" in collider.name:
					if phone_audio and phone_audio.playing:
						phone_audio.stop()
						print("Фонгай замолк!")
				
				# 2. Если смотрим на компьютер — открываем терминал и показываем мышь
				elif "Computer" in collider.name:
					if computer_ui:
						computer_ui.show()
						Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Показываем курсор мыши
						if line_edit:
							line_edit.grab_focus() # Фокус на ввод текста
						print("Компьютер активирован")
