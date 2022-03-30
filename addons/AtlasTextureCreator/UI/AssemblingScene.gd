tool
extends Panel
const CACHED_PATH ="res://addons/AtlasTextureCreator/_cached/"
#folder_name -> data
var _cached_dict={}

func _ready():
	
	_load_cached()
	pass

func _load_cached():
	
	var dir =  Directory.new()
	dir.open("res://addons/AtlasTextureCreator/_cached/")
	
	pass

func dir_contents(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func _on_Button_pressed():
	$StandarSpriteDialog.popup_centered_ratio()

func _on_StandarSpriteDialog_file_selected(path):
	
	var standar_charactor_res = load(path) 
	var standar_charactor = standar_charactor_res.instance()
	
	var folder_name = standar_charactor.get('texture_folder') as String
	var name_array =folder_name.split("/")
	var fileName = name_array[name_array.size()-1]+".tscn"

	var replica =standar_charactor_res.duplicate()
	
	var list = ResourceSaver.get_recognized_extensions(replica)
	print(replica.resource_path)
	var ret = ResourceSaver.save(CACHED_PATH+fileName,replica,ResourceSaver.FLAG_CHANGE_PATH)
	cascadate_save_position_data(standar_charactor_res)

func cascadate_save_position_data(node):
	pass
