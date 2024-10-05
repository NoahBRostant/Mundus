extends Button

@export var img:Texture
@export var title:String
@export var tabid:int
@export var taborder:int

func _ready():
	var siblings = get_parent().get_children()
	for i in siblings:
		i.button_pressed = false
	siblings[0].button_pressed = true
	siblings[0].disabled = true

func _process(delta):
	$MarginContainer/HBoxContainer/VBoxContainer/RichTextLabel.text = title
	$MarginContainer/HBoxContainer/VBoxContainer2/TextureRect.texture = img
	pass


func _on_pressed():
	var siblings = get_parent().get_children()
	self.disabled = true
	for i in siblings:
		if i != self:
			i.disabled = false
			i.button_pressed = false
	var allcontent = self.get_parent().get_node("%ContentPanel").get_children()
	for i in allcontent:
		if i.tabid != tabid:
			i.hide()
		else:
			i.show()


func _on_texture_button_mouse_entered():
	var tween = get_tree().create_tween()
	tween.tween_property($MarginContainer/HBoxContainer/TextureButton, "modulate", Color8(254,139,104), 0.1)


func _on_texture_button_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property($MarginContainer/HBoxContainer/TextureButton, "modulate", Color8(255,255,255), 0.1)


func _on_texture_button_pressed():
	var childeren = self.get_parent().get_node("%ContentPanel").get_children()
	for i in childeren:
		if i.tabid == tabid:
			i.get_parent().remove_child(i)
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property($MarginContainer, "modulate", Color8(255,255,255,0), 0.15)
	tween.tween_property(self, "modulate", Color8(255,255,255,0), 0.2)
	tween.tween_property(self, "custom_minimum_size", Vector2(0,size.y), 0.2)
	await get_tree().create_timer(0.3).timeout
	self.get_parent().remove_child(self)
