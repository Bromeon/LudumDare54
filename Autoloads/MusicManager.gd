extends Node

var played: bool = false

func play_victory_music():
	if not played:
		played = true
		$AudioStreamPlayer.stream = preload("res://Assets/Audio/Neon Laser Horizon.mp3")
		$AudioStreamPlayer.playing = true

