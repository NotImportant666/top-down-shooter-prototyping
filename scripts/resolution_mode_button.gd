extends Control


@onready var option_button = $HBoxContainer/OptionButton as OptionButton

const RESOLUTION_DICTIONARY : Dictionary = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080": Vector2i(1920, 1080)
}

func _ready():
	add_resolution_items()
	load_data()


func load_data() -> void:
	_on_option_button_item_selected(SettingsDataContainer.get_resolution_index())
	option_button.select(SettingsDataContainer.get_resolution_index())




func add_resolution_items() -> void:
	for resolution_size_text in RESOLUTION_DICTIONARY:
		option_button.add_item(resolution_size_text)

func _on_option_button_item_selected(index: int) -> void:
	SettingsSignalBus.emit_on_resolution_selected(index)
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
