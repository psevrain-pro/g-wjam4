extends Node

var num_players = 10
var bus = "master"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p])
		p.bus = bus
	AudioManager.play_intro()

func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)


func play(sound_path):
	queue.append(sound_path)


func _process(delta):
	# Play a queued sound if any players are available.
	if not queue.empty() and not available.empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()

func play_gain():
	play("sons/pickup.mp3")

func play_skel_vs_mob():
	play("sons/blocked.mp3")

func play_mort():
	queue.clear()
	play("sons/terraform1.mp3")

func play_intro():
	play("sons/intro faible.mp3")

func play_spawn():
	play("sons/soul.mp3")
	
func play_duplicate():
	play("sons/pouic_deplacement.mp3")

func play_call():
	play("sons/teleport.wav")

func play_coffre():
	play("sons/etoiles 3.wav")
