tool
extends Panel
const CACHED_PATH ="res://addons/AtlasTextureCreator/_cached/"

const MAKE_TEMPLATE = 1
const USE_TEMPLATE =2

#folder_name -> data
var _cached_dict={}

var _mod =MAKE_TEMPLATE

func _ready():
	_load_cached()

func _load_cached():
	
	_update_cached_dict()
	update_item_list()
	
func _update_cached_dict():
	var dir = Directory.new()
	if dir.open(CACHED_PATH) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name=="." or file_name=="..":
				file_name = dir.get_next()
				continue
			
			_cached_dict[file_name]=load(CACHED_PATH+file_name).instance()
			file_name = dir.get_next()	
	else:
		print("An error occurred when trying to access the path.")

func update_item_list():
	$ItemList.clear()
	for entry in _cached_dict:
		var head =_cached_dict[entry].find_node("head")
		$ItemList.add_item(entry,_cached_dict[entry].find_node("head").texture)
	
	$ItemList.sort_items_by_text()

func _on_StandarSpriteDialog_file_selected(path):
	
	if _mod == MAKE_TEMPLATE:
		#加载待保存的场景（standarcharactor)
		var standar_charactor_res = load(path) 
		var standar_charactor = standar_charactor_res.instance()
		#获得标识名称
		var folder_name = standar_charactor.get('texture_folder') as String
		var name_array =folder_name.split("/")
		var fileName = name_array[name_array.size()-1]+".tscn"
		#待保存数据
		var replica =standar_charactor_res.duplicate()
		#持久化
		var list = ResourceSaver.get_recognized_extensions(replica)
		print(replica.resource_path)
		var ret = ResourceSaver.save(CACHED_PATH+fileName,replica,ResourceSaver.FLAG_CHANGE_PATH)
		if ret ==OK:
			_warn("successfully create template:"+ fileName)
			_update_cached_dict()
			update_item_list()
			pass
			
	elif _mod == USE_TEMPLATE:
		#加载待保存的场景（standarcharactor)
		var standar_charactor_res = load(path)  as PackedScene
		var standar_charactor = standar_charactor_res.instance()
		#获得标识名称
		var folder_name = standar_charactor.get('texture_folder') as String
		var fileName=""
		if folder_name!="":
			var name_array =folder_name.split("/")
			fileName = name_array[name_array.size()-1]+".tscn"
		elif $ItemList.get_selected_items().size()>0:
			var idx = $ItemList.get_selected_items()[0]
			fileName = $ItemList.get_item_text(idx)
		else:
			_warn("the chosed charactor need to hava a correct 'texture_folder' property pointed to a directory.\n if not, choose a template inside 'saved template' you want to use")
			return
		
		if _cached_dict.has(fileName):
			var saved_charactor = _cached_dict[fileName]
			
			use_template(standar_charactor,saved_charactor)
			var r = standar_charactor_res.pack(standar_charactor)
			
			var ret = ResourceSaver.save(path,standar_charactor_res, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)
			if ret ==OK:
				_warn("Apply template success: " +fileName)
				pass
		
	#cascadate_save_position_data(standar_charactor_res)

func _warn(text):
	var warn =AcceptDialog.new()
	warn.dialog_text=text
	add_child(warn)
	warn.popup_centered_minsize()
	yield(warn,"popup_hide")
	warn.queue_free()

#从templat 中copy transform 和 offset 属性到 charactor上的同名 sprite 类型节点
func use_template(charactor,template):
	_cascadate_set_param(charactor,template)

func _cascadate_set_param(node:Node,template:Node):
	
	if node is Sprite:
		
		var sprite = node as Sprite
		
		var template_node = template.find_node(sprite.name)
		if template_node is Sprite:
			#复制属性
			sprite.transform = template_node.transform
			sprite.offset = template_node.offset
		pass
	#迭代式的	
	if node.get_child_count()>0:
		for child in node.get_children():
			_cascadate_set_param(child,template)
			pass
	pass


func cascadate_save_position_data(node):
	pass


func _on_StandarSpriteDialogBtn_pressed():
	_mod = MAKE_TEMPLATE
	$StandarSpriteDialog.popup_centered_ratio()


func _on_UseTemplateBtn_pressed():
	_mod = USE_TEMPLATE
	$StandarSpriteDialog.popup_centered_ratio()


func _on_ItemList_item_rmb_selected(index, at_position):
	if $ItemList.is_selected(index):
		$ItemList.unselect(index)

