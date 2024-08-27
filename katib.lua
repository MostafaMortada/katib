#!/bin/lua

function split(inp, sep)
	local t, e = {}, 1
	
	for c in inp:gmatch(".") do
		if c == sep then
			e = e + 1
		else
			t[e] = (t[e] or "") .. c
		end
	end
	
	return t
end

local text = {}
local line = 1
local filename = ""
local saved = true

function rl()
	os.execute("clear")
	io.write("Katib - ", filename, saved and "" or "*", "\n")
	for i = 1, #text do
		io.write(i, "\t|", text[i], "\n")
	end
end

os.execute("clear")
print("Katib v1.0, made by StephenMortada\nhttps://www.github.com/StephenMortada/katib")

while true do
	io.write(line, "\t|")
	inp = io.read()
	l = inp:len()
	if inp:sub(1, 1) == "\27" then
		if l > 1 then
			local c = inp:sub(2, l)
			if c == "save" then
				io.write("File name? (full path) >")
				filename = io.read()
				local file = io.open(filename, "w")
				file:write(table.concat(text, "\n"))
				file:close()
				saved = true
			elseif c == "load" then
				io.write("File name? (full path) >")
				filename = io.read()
				local file = io.open(filename)
				if file == nil then
					print("E:File not found")
				else
					text = split(file:read("a"), "\n")
					line = 1
					rl()
					saved = true
				end
			elseif c == "quit" then
				if saved then
					break
				end
				io.write("Are you sure you want to quit? Unsaved changes will be lost. (y/n) ")
				local e = io.read()
				if e == "y" then
					break
				end
			elseif c == "goto" then
				io.write("Line=")
				local newline = io.read()
				if tonumber(newline) ~= nil then
					line = math.max(1, math.min(#text + 1, tonumber(newline)))
				else
					print("E:Not a number")
				end
			elseif c == "clear" then
				rl()
			else
				print("E:Invalid")
			end
		else
			print("E:Invalid")
		end
	else
		text[line] = inp
		line = line + 1
		saved = false
	end
end

os.execute("clear")
