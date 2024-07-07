extends Node

var window_mode_index : int = 0
var resolution_index : int = 0
var master_volume : float = 0.0
var music_volume : float = 0.0
var SFX_volume : float = 0.0
var subtitles_set : bool = false




func _ready():
	handle_signals()

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

func handle_signals() -> void:
	SettingsSignalBus.on_window_mode_selected.connect(on_window_mode_selected)
	SettingsSignalBus.on_resolution_selected.connect(on_resolution_selected)
	SettingsSignalBus.on_master_sound_set.connect(on_master_sound_set)
	SettingsSignalBus.on_music_sound_set.connect(on_music_sound_set)
	SettingsSignalBus.on_SFX_sound_set.connect(on_SFX_sound_set)
	SettingsSignalBus.on_subtitles_toggled.connect(on_subtitles_toggled)
