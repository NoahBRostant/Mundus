extends Control

var toggle:bool = false
var selection

@export_multiline var placeholder = ""

var openai = load("res://Scripts/ProphetAI.py")

func _ready():
	$TextEdit.placeholder_text = placeholder

func _process(delta):
	selection = $TextEdit2.get_selected_text()

func _on_TextureButton4_button_up():
	if toggle == false:
		#_md_to_bb($TextEdit.text)
		$Background/MarginContainer/MarkdownLabel.markdown_text = $TextEdit.text
		Global.noteSave = $TextEdit.text
		$TextEdit.hide()
		$Background.show()
		#$TextEdit2.show()
		#$MarkdownLabel.show()
		toggle = true
	else:
		$TextEdit.show()
		$Background.hide()
		#$TextEdit2.hide()
		#$MarkdownLabel.hide()
		toggle = false


func _md_to_bb(mdText:String):
	var bolditalicSplit = mdText.split("***",false)
	print(bolditalicSplit)
	var bbcText = ""
	var count = 0
	for i in bolditalicSplit:
		if i == bolditalicSplit[0]:
			if mdText.begins_with("***"):
				bbcText = "[b][i]"+i+"[/i][/b]"
				count = 1
			else:
				bbcText = i
				count = 0
		elif count == 0:
			bbcText += "[b][i]"+i+"[/i][/b]"
			count = 1
		elif count == 1:
			bbcText += i
			count = 0
		print(bbcText)
	var boldSplit = bbcText.split("**",false)
	print(boldSplit)
	for i in boldSplit:
		if i == boldSplit[0]:
			if mdText.begins_with("**") and not mdText.begins_with("***"):
				bbcText = "[b]"+i+"[/b]"
				count = 1
			else:
				bbcText = i
				count = 0
		elif count == 0:
			bbcText += "[b]"+i+"[/b]"
			count = 1
		elif count == 1:
			bbcText += i
			count = 0
		print(bbcText)
	var italicSplit = bbcText.split("*",false)
	print(italicSplit)
	for i in italicSplit:
		if i == italicSplit[0]:
			if mdText.begins_with("*") and not mdText.begins_with("**") and not mdText.begins_with("***"):
				bbcText = "[i]"+i+"[/i]"
				count = 1
			else:
				bbcText = i
				count = 0
		elif count == 0:
			bbcText += "[i]"+i+"[/i]"
			count = 1
		elif count == 1:
			bbcText += i
			count = 0
		print(bbcText)
	var codeSplit = bbcText.split("```",false)
	print(codeSplit)
	for i in codeSplit:
		if i == codeSplit[0]:
			if mdText.begins_with("```-rounded\n"):
				i = i.trim_prefix("-rounded\n")
				var length = i.length() + 2
				bbcText = "\n[font=res://Font/Mono.tres][color=#717171]╭"
				for c in length:
					bbcText += "─"
				bbcText += "╮\n│ [color=#ca5e6e]"+i+"[color=#717171] │\n╰"
				for c in length:
					bbcText += "─"
				bbcText += "╯[/color][/color][/color][/font]\n"
				count = 1
			elif mdText.begins_with("```"):
				var length = i.length() + 2
				bbcText = "\n[font=res://Font/Mono.tres][color=#717171]┌"
				for c in length:
					bbcText += "─"
				bbcText += "┐\n│ [color=#ca5e6e]"+i+"[color=#717171] │\n└"
				for c in length:
					bbcText += "─"
				bbcText += "┘[/color][/color][/color][/font]\n"
				count = 1
			else:
				bbcText = i
				count = 0
		elif count == 0:
			var length = i.length() + 2
			bbcText += "\n[font=res://Font/Mono.tres][color=#717171]┌"
			for c in length:
				bbcText += "─"
			bbcText += "┐\n│ [color=#ca5e6e]"+i+"[color=#717171] │\n└"
			for c in length:
				bbcText += "─"
			bbcText += "┘[/color][/color][/color][/font]\n"
			count = 1
		elif count == 1:
			bbcText += i
			count = 0
		print(bbcText)
	var lineSplit = bbcText.split("\n",true)
	print(lineSplit)
	var temp = ""
	for i in lineSplit:
		if i.begins_with("# "):
			temp += "[font=res://Font/H1.tres]"+i.trim_prefix("# ")+"[/font]\n"
		elif i.begins_with("## "):
			temp += "[font=res://Font/H2.tres]"+i.trim_prefix("## ")+"[/font]\n"
		elif i.begins_with("### "):
			temp += "[font=res://Font/H3.tres]"+i.trim_prefix("### ")+"[/font]\n"
		elif i.begins_with("#### "):
			temp += "[font=res://Font/H4.tres]"+i.trim_prefix("#### ")+"[/font]\n"
		elif i.begins_with("##### "):
			temp += "[font=res://Font/H5.tres]"+i.trim_prefix("##### ")+"[/font]\n"
		elif i.begins_with("###### "):
			temp += "[font=res://Font/H6.tres]"+i.trim_prefix("###### ")+"[/font]\n"
		else:
			temp += i+"\n"
	bbcText = temp
	$TextEdit2.text = bbcText

func _input(event):
	if event.is_action_pressed("openai_gpt"):
		var gptprompt:String
		Global.noteSave = $TextEdit.text
		_md_to_bb($TextEdit.text)
		if $TextEdit2.text.length() > 500:
			gptprompt = $TextEdit2.text.right(500)
		else:
			gptprompt = $TextEdit2.text
		Global.gptTokenLimit = Global.gptTokenDefault
		Global.openaiRequest = gptprompt
		$TextEdit.text += Global.openaiResponse


func _on_TextureButton5_button_up():
	var gptprompt:String
	Global.noteSave = $TextEdit.text
	_md_to_bb($TextEdit.text)
	if selection.length() > 0:
		gptprompt = selection
	elif $TextEdit2.text.length() > 1000:
		gptprompt = $TextEdit2.text.right(1000)
	else:
		gptprompt = $TextEdit2.text
	Global.gptTokenLimit = Global.gptTokenDefault
	Global.openaiRequest = gptprompt
	$TextEdit.text += Global.openaiResponse
