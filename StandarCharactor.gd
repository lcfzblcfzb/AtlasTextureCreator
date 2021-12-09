tool
extends Sprite

export(String, DIR, GLOBAL) var texture_folder
# Called when the node enters the scene tree for the first time.
func _ready():
	
	casacade_set_texture(self)	
#	cascade_set_null(self)
	pass # Replace with function body.

func casacade_set_texture(node:Sprite):
	var fn = texture_folder+"/"+node.name+".tres"
	node.texture = load(fn)
		
	for child in node.get_children():
		casacade_set_texture(child)
	pass

func cascade_set_null(node:Sprite):
	node.texture = null
	
	for child in node.get_children():
		cascade_set_null(child)
	
	pass
