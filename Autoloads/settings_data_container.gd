extends Node

@onready var default_settings : DefaultSettingsResource = preload("res://Resources/settings resources/default_settings.tres")
@onready var keybind_resource : PlayerKeybindResource = preload("res://Resources/settings resources/player_keybind_default.tres")

var window_mode_index : int = 0
var resolution_index : int = 0
var master_volume : float = 0.0
var music_volume : float = 0.0
var SFX_volume : float = 0.0
var subtitles_set : bool = false
var loaded_data : Dictionary = {}




func _ready():
	handle_signals()
	create_storage_dictionary()



func create_storage_dictionary() -> Dictionary:
	var settings_container_dict : Dictionary = {
		"window_mode_index" : window_mode_index,
		"resolution_index" : resolution_index,
		"master_volume" : master_volume,
		"music_volume" : music_volume,
		"SFX_volume" : SFX_volume,
		"subtitles_set" : subtitles_set,
		"keybinds" : create_keybinds_dictionary()
		
	}
	
	return settings_container_dict


func create_keybinds_dictionary() -> Dictionary:
	var keybinds_container_dict = {
		keybind_resource.MOVE_LEFT : keybind_resource.move_left_key,
		keybind_resource.MOVE_RIGHT : keybind_resource.move_right_key,
		keybind_resource.MOVE_UP : keybind_resource.move_up_key,
		keybind_resource.MOVE_DOWN : keybind_resource.move_down_key
	}
	return keybinds_container_dict


func get_window_mode_index() -> int:
	if loaded_data == {}:
		return default_settings.DEFAULT_WINDOW_MODE_INDEX
	return window_mode_index

func get_resolution_index() -> int:
	if loaded_data == {}:
		return default_settings.DEFAULT_RESOLUTION_INDEX
	return resolution_index

func get_master_volume() -> float:
	if loaded_data == {}:
		return default_settings.DEFAULT_MASTER_VOLUME
	return master_volume

func get_music_volume() -> float:
	if loaded_data == {}:
		return default_settings.DEFAULT_MUSIC_VOLUME
	return music_volume

func get_SFX_volume() -> float:
	if loaded_data == {}:
		return default_settings.DEFAULT_SFX_VOLUME
	return SFX_volume

func get_subtitles_set() -> bool:
	if loaded_data == {}:
		return default_settings.DEFAULT_SUBTITLES_SET
	return subtitles_set


func get_keybind(action : String):
	if !loaded_data.has("keybinds"):
		match action:
			keybind_resource.MOVE_LEFT:
				return keybind_resource.DEFAULT_MOVE_LEFT_KEY
			keybind_resource.MOVE_RIGHT:
				return keybind_resource.DEFAULT_MOVE_RIGHT_KEY
			keybind_resource.MOVE_UP:
				return keybind_resource.DEFAULT_MOVE_UP_KEY
			keybind_resource.MOVE_DOWN:
				return keybind_resource.DEFAULT_MOVE_DOWN_KEY
	else:
		match action:
			keybind_resource.MOVE_LEFT:
				return keybind_resource.move_left_key
			keybind_resource.MOVE_RIGHT:
				return keybind_resource.move_right_key
			keybind_resource.MOVE_UP:
				return keybind_resource.move_up_key
			keybind_resource.MOVE_DOWN:
				return keybind_resource.move_down_key


func on_window_mode_selected(index : int) -> void:
	window_mode_index = index

func on_resolution_selected(index : int) -> void:
	resolution_index = index

func on_master_sound_set(value : float) -> void:
	master_volume = value

func on_music_sound_set(value : float) -> void:
	music_volume = value

func on_SFX_sound_set(value : float) -> void:
	SFX_volume = value

func on_subtitles_toggled(toggled : bool) -> void:
	subtitles_set = toggled

func set_keybind(action : String, event) -> void:
	match action:
		keybind_resource.MOVE_LEFT:
			keybind_resource.move_left_key = event
		keybind_resource.MOVE_RIGHT:
			keybind_resource.move_right_key = event
		keybind_resource.MOVE_UP:
			keybind_resource.move_up_key = event
		keybind_resource.MOVE_DOWN:
			keybind_resource.move_down_key = event


func on_keybinds_loaded(data : Dictionary) -> void:
	var loaded_move_left = InputEventKey.new()
	var loaded_move_right = InputEventKey.new()
	var loaded_move_up = InputEventKey.new()
	var loaded_move_down = InputEventKey.new()
	
	loaded_move_left.set_physical_keycode(int(data.left))
	loaded_move_right.set_physical_keycode(int(data.right))
	loaded_move_up.set_physical_keycode(int(data.up))
	loaded_move_down.set_physical_keycode(int(data.down))
	
	keybind_resource.move_left_key = loaded_move_left
	keybind_resource.move_right_key = loaded_move_right
	keybind_resource.move_up_key = loaded_move_up
	keybind_resource.move_down_key = loaded_move_down

func on_settings_data_loaded(data : Dictionary) -> void:
	loaded_data = data
	
	on_window_mode_selected(loaded_data.window_mode_index)
	on_resolution_selected(loaded_data.resolution_index)
	on_master_sound_set(loaded_data.master_volume)
	on_music_sound_set(loaded_data.music_volume)
	on_SFX_sound_set(loaded_data.SFX_volume)
	on_subtitles_toggled(loaded_data.subtitles_set)
	on_keybinds_loaded(loaded_data.keybinds)
	

func handle_signals() -> void:
	SettingsSignalBus.on_window_mode_selected.connect(on_window_mode_selected)
	SettingsSignalBus.on_resolution_selected.connect(on_resolution_selected)
	SettingsSignalBus.on_master_sound_set.connect(on_master_sound_set)
	SettingsSignalBus.on_music_sound_set.connect(on_music_sound_set)
	SettingsSignalBus.on_SFX_sound_set.connect(on_SFX_sound_set)
	SettingsSignalBus.on_subtitles_toggled.connect(on_subtitles_toggled)
	SettingsSignalBus.load_settings_data.connect(on_settings_data_loaded)
