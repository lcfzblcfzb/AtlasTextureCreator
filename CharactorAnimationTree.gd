class_name CharactorAnimationTree
extends AnimationTree

const ATTACK_ACTION_BLEND = "parameters/attack_action_blend/blend_amount"
const ATTACK_TRAN = "parameters/attack_tran/current"
const ENGAGED_TRAN ="parameters/engaged_tran/current"

const ENGAGED_BT_SHOT="parameters/engaged_bt/shot/active"
const ENGAGED_BT_BS ="parameters/engaged_bt/bs/blend_position"
const ENGAGED_BT_SHOT_TRAN ="parameters/engaged_bt/shot_tran/current"

const PEACE_BT_BS = "parameters/peace_bt/bs/blend_position"
const PEACE_BT_SHOT ="parameters/peace_bt/shot/active"
const PEACE_BT_SHOT_TRAN ="parameters/peace_bt/shot_tran/current"

var _bs_vector = Vector2.ZERO

#更新blend space 2d 的参数
func _update_bs_vector():
	set(PEACE_BT_BS,_bs_vector)
	set(ENGAGED_BT_BS,_bs_vector)
	pass

func peace_idle():
	set(ATTACK_ACTION_BLEND,0)
	set(ATTACK_TRAN,2)
	set(ENGAGED_TRAN,1)
	
	_bs_vector = Vector2.ZERO
	_update_bs_vector()
	
	set(ENGAGED_BT_SHOT,false)
	print("peace_idling")

func peace_jump():
	set(PEACE_BT_SHOT_TRAN,0)
	set(PEACE_BT_SHOT,true)
	print("jumping")
	
func peace_air_up():
	_bs_vector.y = 1
	_update_bs_vector()
	print("on air up")
	
func peace_air_down():
	_bs_vector.y = -1
	_update_bs_vector()
	print("on air down")

func peace_walk():
	_bs_vector.x =0.5
	_update_bs_vector()
	
func peace_run():
	_bs_vector.x =1
	_update_bs_vector()

func peace_attack():
	set("parameters/Seek/seek_position",0)
	set(ATTACK_ACTION_BLEND,1)
	set(ATTACK_TRAN ,0)

func peace_attack_end():
	set(ATTACK_ACTION_BLEND,0)
	set(ATTACK_TRAN,2)
		
func _physics_process(delta):
	
	
	pass

