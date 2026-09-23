@tool
class_name CameraSettingsSlider extends Control

@export var camera_preview: CameraPreview

@export var setting_name: String:
	set(new_setting_name):
		setting_name = new_setting_name
		if is_node_ready():
			_set_label()

@export var command: String
@export var settings: CameraSettings:
	set(new_settings):
		settings = new_settings
		if is_node_ready():
			_setup()

@export var camera_settings_label: Label
@export var camera_settings_slider: HSlider


func _ready() -> void:
	_setup()


func _setup() -> void:
	if not camera_settings_slider or not camera_settings_label:
		return

	if not settings:
		camera_settings_slider.max_value = 0
		camera_settings_slider.value = 0
		_set_label()
		return

	camera_settings_slider.min_value = 0
	camera_settings_slider.max_value = settings.values.size() - 1
	camera_settings_slider.step = 1
	camera_settings_slider.tick_count = settings.values.size()

	_set_label()


func _set_label() -> void:
	if not camera_settings_label:
		return

	if not settings or settings.values.is_empty():
		camera_settings_label.text = setting_name + ": -"
		return

	var index: int = int(camera_settings_slider.value)

	if index >= settings.values.size():
		camera_settings_label.text = setting_name + ": -"
		return

	camera_settings_label.text = setting_name + ": " + settings.values[index]


func _slider_value_changed(new_idx: float) -> void:
	_set_label()

	if not camera_preview:
		push_error("No CameraPreview found: " + name)
		return

	if not settings or settings.values.is_empty():
		return

	var value: String = str(int(new_idx))
	camera_preview.set_config(command, value)
