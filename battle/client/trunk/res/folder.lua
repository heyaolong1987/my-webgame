--使用Lua遍历指定目录，获取所有文件，并使用自定义的函数处理每一个文件
--遍历目录，并对所有的文件进行处理
function get_dir_file(dirpath,func)
    --os.execute("dir " .. dirpath .. " /s > temp.txt")
    os.execute('dir "' .. dirpath .. '" /s > temp.txt')
    io.input("temp.txt")
    local dirname = ""
    local filename = ""
    for line in io.lines() do
        local a,b,c
        --匹配目录
        a,b,c=string.find(line,"^%s*(.+)%s+的目录")
        if a then
         dirname = c
         --print(c)
     end
     --匹配文件
        a,b,c=string.find(line,"^%d%d%d%d%-%d%d%-%d%d%s-%d%d:%d%d%s-[%d%,]+%s+(.+)%s-$")
        if a then
         filename = c
         --print(c)
         func(dirname .. "\\" .. filename)
        end
     --print(line)
    end
end
--获取指定的最后一个字符的位置
function get_last_word(all,word)
    local b = 0
    local last = nil
    while true do
        local s,e = string.find(all, word, b) -- find 'next' word
        if s == nil then
         break
        else
         last = s
        end
         b = s + string.len(word)
    end
    return last
end

function newStack ()
  return {""}   -- starts with an empty string
end

function addString (stack, s)
  table.insert(stack, s)    -- push 's' into the the stack
  for i=table.getn(stack)-1, 1, -1 do
	if string.len(stack[i]) > string.len(stack[i+1]) then
	  break
	end
	stack[i] = stack[i] .. table.remove(stack)
  end
end

function toString(stack)
	return table.concat(stack)
end

s = newStack()
function push(word)
	local ext = string.sub(word,-4)
	if ext == ".swf" or ext == ".jpg" then
		local _,startNum = string.find(word, "res\\", 1)
		--print("startNum:",startNum)
		local str = string.sub(word,startNum)
		addString(s,"'"..str.."',\n")
	end
end

--可以通过get_last_word获取指定文件的相应路径和相应文件名
get_dir_file('./',push)

io.output("list.txt")
io.write(toString(s))
