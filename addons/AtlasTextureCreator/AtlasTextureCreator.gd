tool
extends EditorPlugin

var dock
var asemble

func _enter_tree():
	
	dock = preload("res://addons/AtlasTextureCreator/UI/Main.tscn").instance()
	add_control_to_dock(DOCK_SLOT_LEFT_UL,dock)
	
	asemble = preload("res://addons/AtlasTextureCreator/UI/AssemblingScene.tscn").instance()
	add_control_to_dock(DOCK_SLOT_LEFT_UL,asemble)

func _exit_tree():
	
	remove_control_from_docks(dock)
	dock.free()
	
	remove_control_from_docks(asemble)
	asemble.free()
