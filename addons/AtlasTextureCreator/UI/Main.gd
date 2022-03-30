tool
extends Panel

var chosed_png_path
var chosed_json_path
var saved_folder_path

func _ready():
	pass # Replace with function body.

func _on_choose_png_pressed():
	$chosed_json.text="clicked"
	
	if $json_dialog.current_dir!="":
		$png_dialog.current_dir=$json_dialog.current_dir
	
	$png_dialog.popup_centered_ratio()
	yield($png_dialog,"popup_hide")
	chosed_png_path =$png_dialog.current_path
	$chosed_png.text = chosed_png_path

func _on_choose_json_pressed():
	$json_dialog.popup_centered_ratio()
	
	if $png_dialog.current_dir!="":
		$json_dialog.current_dir=$png_dialog.current_dir
	
	yield($json_dialog,"popup_hide")
	chosed_json_path =$json_dialog.current_path
	$chosed_json.text = chosed_json_path

#发现重复资源时候的处理方式  --全部覆盖
var overwrite_all = false
func _on_confirm_pressed():
	
	if saved_folder_path==null:
		$saved_folder_dialog.popup_centered_ratio()
		yield($saved_folder_dialog,"hide")
		
	if chosed_json_path==null || chosed_png_path ==null:
		var warn_dialog =AcceptDialog.new()
		warn_dialog.dialog_text="not valid path"
		add_child(warn_dialog)
		warn_dialog.popup_centered()
		yield(warn_dialog,"popup_hide")
		remove_child(warn_dialog)
		warn_dialog.queue_free()
		return
	
	var texture = load(chosed_png_path)
	var json = load_json_file(chosed_json_path)
	
	var bodyPartConfig = json.frames
	var atlas_map = {}
	
	var count = 0;
	for item in bodyPartConfig:
		
		var jsonitem = bodyPartConfig.get(item)
		var rect = Rect2(jsonitem.frame.x,jsonitem.frame.y,jsonitem.frame.w,jsonitem.frame.h)
		
		var atlas_texture = AtlasTexture.new()
		atlas_texture.atlas = texture
		atlas_texture.region = rect
		atlas_map[item] = atlas_texture
		
		var fn = saved_folder_path+"/"+item+".tres"
#		print(fn)
		#检查重复
		if ResourceLoader.exists(fn) and not overwrite_all:
			
			var confirm_dialog_ignore = ConfirmationDialog.new()
			var how_to ={}
			
			confirm_dialog_ignore.dialog_hide_on_ok = false
			confirm_dialog_ignore.dialog_text="there is already a "+item+" exist,do you want to overwrite it?"
			confirm_dialog_ignore.get_ok().visible=false
			confirm_dialog_ignore.add_button("overwrite",false,"overwrite")
			confirm_dialog_ignore.add_button("overwrite all",false,"overwrite_all")
			confirm_dialog_ignore.add_button("no",false,"no")
			
			var cancel_btn =confirm_dialog_ignore.get_cancel() as Button
			cancel_btn.connect("pressed",self,"_handle_confir_cancle",[how_to,confirm_dialog_ignore])
			confirm_dialog_ignore.connect("custom_action",self,"_handle_confirm_dialog_ignore",[how_to,confirm_dialog_ignore])
			add_child(confirm_dialog_ignore)
			confirm_dialog_ignore.popup_centered_ratio()
			yield(confirm_dialog_ignore,"hide")
			
			remove_child(confirm_dialog_ignore)
			confirm_dialog_ignore.queue_free()
			if how_to.has("overwrite"):
				pass
			elif how_to.has("overwrite_all"):
				overwrite_all= true
				pass
			elif how_to.has("no"):
				continue
				pass
			elif how_to.has("cancel"):
				break
				pass	
			else:
				continue
				pass
		print(ResourceSaver.save(fn,atlas_texture))
		count+=1
	
	#弹出处理结果
	var warn_dialog =AcceptDialog.new()
	warn_dialog.popup_exclusive = true
	if count>0:
		warn_dialog.dialog_text="succeccfully create total atlas file %d"  % count
	else:
		warn_dialog.dialog_text="nothing changed"
	
	overwrite_all = false
	
	add_child(warn_dialog)
	warn_dialog.popup_centered()
	yield(warn_dialog,"popup_hide")
	remove_child(warn_dialog)
	warn_dialog.queue_free()
	

#从text文件中读取json 并保存为json对象
func load_json_file(path):
	"""Loads a JSON file from the given res path and return the loaded JSON object."""
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	if result_json.error != OK:
		print("\tError: ", result_json.error)
		print("\tError Line: ", result_json.error_line)
		print("\tError String: ", result_json.error_string)
		return null
	var obj = result_json.result
	return obj


func _on_saved_folder_dialog_popup_hide():
	saved_folder_path = $saved_folder_dialog.current_dir
	$saved_folder.text = saved_folder_path

func _on_saved_folder_gui_input(event):
	
	if event is InputEventMouseButton:
		if event.pressed:
			$saved_folder_dialog.popup_centered_ratio()
			yield($saved_folder_dialog,"hide")

#发现重复资源时候的 确认
func _handle_confirm_dialog_ignore(action,b,dialog):
	b[action]=action
	dialog.hide()
#发现重复资源时候的 确认
func _handle_confir_cancle(b,dialog):
	b["cancel"]="cancel"
	dialog.hide()
	
