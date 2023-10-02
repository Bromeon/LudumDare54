extends Node

func play_victory_music():
	$AudioStreamPlayer.stream = preload("res://Assets/Audio/Neon Laser Horizon.mp3")
	$AudioStreamPlayer.playing = true

