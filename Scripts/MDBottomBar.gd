extends TextEdit


func split(s: String, delimeters, allow_empty: bool = true) -> Array:
	var parts := []
	
	var start := 0
	var i := 0
	
	while i < s.length():
		if s[i] in delimeters:
			if allow_empty or start < i:
				parts.push_back(s.substr(start, i - start))
			start = i + 1
		i += 1
	
	if allow_empty or start < i:
		parts.push_back(s.substr(start, i - start))
	
	return parts

func _on_TextEdit_text_changed():
	var wordcount = split($".".text,[" ","\n"], false).size()
	var charcount = $".".text.replace("\n","").length()
	$"../ColorRect/HBoxContainer/WordCount".text = str(wordcount)+" Words "+str(charcount)+" Characters"
