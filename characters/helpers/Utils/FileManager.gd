func files_with_pattern_in_directory(path, pattern):
	var files = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file = dir.get_next()
		
		while (file != ""):
			if not dir.current_is_dir():
				if file.match(pattern):
					files.append(file)
			file = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return files
