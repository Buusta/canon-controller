class_name CameraPreview extends CanvasLayer

@export var preview_texture_rect: TextureRect
@export var fps: int = 10

var process: Dictionary = {}
var preview_texture: ImageTexture
var timer: Timer

const LAUNCH_ARGUMENTS := [
	"--force-overwrite",
	"--filename=/tmp/preview.jpg",
	"--shell",
]


func _ready() -> void:
	process = OS.execute_with_pipe("/usr/bin/gphoto2", LAUNCH_ARGUMENTS)

	preview_texture = ImageTexture.new()
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0 / fps
	timer.timeout.connect(_take_picture)
	timer.start()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_cleanup()


func _send_command(command: String) -> void:
	if process.is_empty(): return

	process["stdio"].store_string(command + "\n")
	process["stdio"].flush()


func set_config(config: String, value: String) -> void:
	var cmd: String = "set-config " + config + "=" + value
	_send_command(cmd)
	print(cmd)


func _take_picture() -> void:
	if process.is_empty(): return

	_send_command("capture-preview")
	_update_preview()


func _update_preview() -> void:
	var image := Image.load_from_file("/tmp/thumb_preview.jpg")

	if image == null:
		return

	preview_texture = ImageTexture.create_from_image(image)
	preview_texture_rect.texture = preview_texture


func _cleanup() -> void:
		if process.is_empty(): return

		process["stdio"].close()
		OS.kill(process["pid"])
