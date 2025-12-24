extends StaticBody3D

var playing = false


func activate():
	playing = not playing
	if playing:
		Wwise.post_event("Play_Contraption_Loop", self)
	else:
		Wwise.post_event("Stop_Contraption_Loop", self)
	
