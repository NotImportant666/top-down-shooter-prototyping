extends Node2D


@onready var player = $Player

func _ready():
	player.cutsceneIsPlaying = false

