
return function(env)
	return function(key, value)
		env[key] = value
		return value
	end
end