--ʹ��Lua����ָ��Ŀ¼����ȡ�����ļ�����ʹ���Զ���ĺ�������ÿһ���ļ�
--����Ŀ¼���������е��ļ����д���
function get_dir_file(dirpath,func)
    --os.execute("dir " .. dirpath .. " /s > temp.txt")
    os.execute('dir "' .. dirpath .. '" /s > temp.txt')
    io.input("temp.txt")
    local dirname = ""
    local filename = ""
    for line in io.lines() do
        local a,b,c
        --ƥ��Ŀ¼
        a,b,c=string.find(line,"^%s*(.+)%s+��Ŀ¼")
        if a then
         dirname = c
         --print(c)
     end
     --ƥ���ļ�
        a,b,c=string.find(line,"^%d%d%d%d%-%d%d%-%d%d%s-%d%d:%d%d%s-[%d%,]+%s+(.+)%s-$")
        if a then
         filename = c
         --print(c)
         func(dirname .. "\\" .. filename)
        end
     --print(line)
    end
end
--��ȡָ�������һ���ַ���λ��
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

--����ͨ��get_last_word��ȡָ���ļ�����Ӧ·������Ӧ�ļ���
get_dir_file('./',push)

io.output("list.txt")
io.write(toString(s))
