extends PanelContainer

func update_info(title:String, description:String, logo:Texture):
	$MarginContainer/VBoxContainer/PanelContainer/MarginContainer2/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/Label.text = title
	$MarginContainer/VBoxContainer/PanelContainer/MarginContainer2/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/MarkdownLabel.markdown_text = description
	$MarginContainer/VBoxContainer/PanelContainer/MarginContainer2/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/TextureRect.texture = logo
