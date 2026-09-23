@tool
class_name CameraSettingsOption extends Control

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
@export var camera_settings_option: OptionButton


func _ready() -> void:
	_setup()


func _setup() -> void:
	if not camera_settings_option or not camera_settings_label:
		return

	camera_settings_option.clear()

	if not settings:
		_set_label()
		return

	for value in settings.values:
		camera_settings_option.add_item(value)

	_set_label()


func _set_label() -> void:
	if not camera_settings_label:
		return

	camera_settings_label.text = setting_name
#
	#if not settings or settings.values.is_empty():
		#camera_settings_label.text = setting_name + ": -"
		#return
#
	#var index := camera_settings_option.selected
#
	#if index < 0 or index >= settings.values.size():
		#camera_settings_label.text = setting_name + ": -"
		#return
#
	#camera_settings_label.text = setting_name + ": " + settings.values[index]


func _option_selected(index: int) -> void:
	_set_label()

	if not camera_preview:
		push_error("No CameraPreview found: " + name)
		return

	if not settings or index >= settings.values.size():
		return

	var value: String = str(int(index))
	camera_preview.set_config(command, value)
