extends Button
var my_fruit : String = "Hello"
var my_number : int
# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if get_parent_control().boxes_clicked % 2 == 0:
	pass


func _on_pressed():
	$Turn.play()
	self.disabled
	$Curtain.hide()
	get_parent().update_fruit(my_fruit, my_number)
	get_parent().boxes_clicked += 1
	await get_tree().create_timer(1.5).timeout
	$Curtain.show()
	
	
	
	
# Assume you have a parent node with 10 buttons, all named "Button1", "Button2", ..., "Button10"
# You have a list of textures you want to assign to these buttons.

# This script can be attached to the parent node containing the buttons
  # Array containing textures to assign to buttons
#res://Assets/Graphics/Fruits and veggies/Acorn_96x96.png
	

