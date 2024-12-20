extends PanelContainer

var article_item = preload("res://Scenes/ArticleNodeItem.tscn")
var items

func _ready():
	var info = ConfigFile.new()
	var dir = DirAccess.open("user://core")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				var err = info.load("user://core/"+file_name+"/plugin.ini")
				if err != OK:
					break
				var inst = article_item.instantiate()
				inst.title = info.get_value("plugin", "name")
				inst.description = info.get_value("plugin", "description")
				var image_texture = conv_path_to_img("user://core/"+file_name+"/"+info.get_value("plugin", "image"))
				$MarginContainer/VBoxContainer/PanelContainer/MarginContainer2/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/TextureRect.texture = image_texture
				#inst.shorthand_img = info.get_value("plugin", "icon")
				inst.filepath = info.get_value("plugin", "init")
				inst.core = true
				%ArticleList.add_child(inst)
			file_name = dir.get_next()
	items = %ArticleList.get_children()


func update_info(title:String, description:String, logo:Texture):
	$MarginContainer/VBoxContainer/PanelContainer/MarginContainer2/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/Label.text = title
	$MarginContainer/VBoxContainer/PanelContainer/MarginContainer2/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/MarkdownLabel.markdown_text = description
	$MarginContainer/VBoxContainer/PanelContainer/MarginContainer2/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/TextureRect.texture = logo


func conv_path_to_img(image_path):
	var image = Image.new()
	var error = image.load(image_path)
	if error != OK:
		$MarginContainer/VBoxContainer/PanelContainer/MarginContainer2/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/TextureRect/TextureRect2.show()
	image.load(image_path)
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	return image_texture


func _on_line_edit_text_changed(new_text: String) -> void:
	if new_text != "":
		for i in items:
			if new_text.to_lower() in i.title.to_lower() or new_text.similarity(i.title) > 0.3 or new_text.similarity(i.description) > 0.2:
				i.show()
			else:
				i.hide()
	else:
		for i in items:
			i.show()
