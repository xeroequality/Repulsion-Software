Logger = {}

Logger.error = function(msg)
	print("ERROR: " .. msg)
end

Logger.debug = function(msg)
	print("DEBUG: " .. msg)
end

Logger.test = function(msg)
	print("TEST: " .. msg)
end

Logger.general = function(msg)
	print("LOG: " .. msg)
end

return Logger