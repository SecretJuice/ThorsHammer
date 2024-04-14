extends Node

var active_track: AudioStreamPlayer = null
var incoming_track: AudioStreamPlayer = null

var clip_track: AudioStreamPlayer = AudioStreamPlayer.new()

var current_transition_rate: float = 1.0

var fading: bool = false

func _ready():
	add_child(clip_track)

func play_sound(stream: AudioStream):
	var instance = AudioStreamPlayer.new()
	instance.stream = stream
	instance.bus = "Effects"
	instance.finished.connect(remove_node.bind(instance))
	add_child(instance)
	instance.play()

func play_from_path(path: String):
	var sound: AudioStream = load(path)
	play_sound(sound)

func play_clip(stream: AudioStream):
	clip_track.stop()
	clip_track.stream = stream
	clip_track.bus = "Voices"
	clip_track.play()

func remove_node(instance: AudioStreamPlayer):
	instance.queue_free()

func play_music(stream: AudioStream, transition_rate: float = 2.0):
	var instance = AudioStreamPlayer.new()
	instance.stream = stream
	instance.bus = "Music"
	instance.finished.connect(remove_node.bind(instance))

	print(active_track, incoming_track)

	if active_track != null:
		instance.volume_db = -80
		incoming_track = instance
		fading = true
	else:
		instance.volume_db = 0
		active_track = instance

	add_child(instance)
	instance.play()
	
	print(active_track, incoming_track)
		
	
	current_transition_rate = transition_rate

func _process(delta: float):

	if fading:
		AdjustMusicVolume(delta)


func AdjustMusicVolume(timestep: float):
	
	if active_track != null and incoming_track != null:
		active_track.volume_db -= 80 * timestep / current_transition_rate
		incoming_track.volume_db += 80 * timestep / current_transition_rate

		print(active_track.volume_db, incoming_track.volume_db)
	
	if incoming_track.volume_db >= 0:
		
		active_track.volume_db = 0
		incoming_track.volume_db = -80

		active_track.stream = incoming_track.stream
		active_track.play(incoming_track.get_playback_position())
		incoming_track.stop()
		fading = false
		remove_node(incoming_track)