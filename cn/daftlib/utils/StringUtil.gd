class_name StringUtil

# Input: "Long <shake>long<beat><shake> time <take>ago..."
# Output: ["Long long time ago...", "shake", 5, "beat", 9, "shake", 9, "take", 15]
static func extractTags(input_string: String) -> Array:
	var pattern := "<(.*?)>"
	var regex := RegEx.new()
	regex.compile(pattern)

	var result := []
	var matched := regex.search_all(input_string)
	var allTagLengthTotal = 0
	for m in matched:
		var tag := m.get_string(0)
		var tag_content := m.get_string(1)
		var tag_position := m.get_start(0)
		
		tag_position -= allTagLengthTotal
		allTagLengthTotal += tag.length()
		
		result.append(tag_content)
		result.append(tag_position)
		input_string = input_string.replace(tag, "")
#		print(tag, input_string)
#		matched = regex.search_all(input_string)

	result.insert(0, input_string)
	return result

# Input: "<fast>What do you want?(Drink glass of water.|Take a snap.)"
# Output: ["<fast>What do you want?", "Drink glass of water.", "Take a snap."]
static func extractOptions(input_string: String) -> Array:
	var pattern := "\\((.*?)\\)"
	var regex := RegEx.new()
	regex.compile(pattern)
	
	var result := []
	var matched := regex.search(input_string)
	if matched:
		var options := matched.get_string(0)
		var options_content := matched.get_string(1)
		result = options_content.split("|")
		input_string = input_string.replace(options, "")
	
	result.insert(0, input_string)
	return result
