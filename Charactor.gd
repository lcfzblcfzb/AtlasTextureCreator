extends Node2D

onready var tree = $AnimationTree as CharactorAnimationTree

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	
	if event.is_action_pressed("ui_accept"):
		
		tree.peace_jump()
		tree.peace_air_up()
		
		yield(get_tree().create_timer(1),"timeout")
		tree.peace_air_down()

		yield(get_tree().create_timer(1),"timeout")
		tree.peace_idle()
	
	var x_direction =event.get_action_strength("ui_right")-event.get_action_strength("ui_left")
	
	if x_direction>0:
		tree.peace_walk()
	
	if event.is_action_pressed("ui_cancel"):
		tree.peace_attack()
		yield(get_tree().create_timer(1),"timeout")	
		tree.peace_attack_end()
