extends AnimationNode

export(AnimationNode) var node

var _time =0

func process(time,seek):
#	if _time >get("Members/_time"):
#		_time = 0
	_time+=time
	print("this is a my animation node!")
	print(get_parameter("parameters/Seek/seek_position"))
	blend_animation("attack",_time,time,seek,0.1)
	
	print(get_parameter("lcf"))
func get_parameter_list():
	
	return ["total_time"]

func get_caption():
	return "lcf node"
