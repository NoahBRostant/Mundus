extends Control

@export var title:String

var toggle = true

func _process(delta):
	$Button/HBoxContainer/Label.text = title
	if $CollapsibleContainer/MarginContainer/VBoxContainer.get_child_count() == 0:
		$Button/HBoxContainer/MarginContainer2.hide()


func _on_button_pressed():
	if toggle == true:
		var tween = get_tree().create_tween()
		tween.tween_property($Button/HBoxContainer/MarginContainer2/Control/TextureRect, "rotation_degrees", -90, 0.15)
		$CollapsibleContainer.open_tween()
		toggle = false
	else:
		var tween = get_tree().create_tween()
		tween.tween_property($Button/HBoxContainer/MarginContainer2/Control/TextureRect, "rotation_degrees", 0, 0.15)
		$CollapsibleContainer.close_tween()
		self.get_parent().get_parent().get_parent().force_update_transform()
		#if self.get_parent().get_parent().get_parent() is CollapsibleContainer:
			#await get_tree().create_timer(0.3).timeout
			#self.get_parent().get_parent().get_parent().close_tween()
			#await get_tree().create_timer(0.1).timeout
			#self.get_parent().get_parent().get_parent().open_tween()
		toggle = true
