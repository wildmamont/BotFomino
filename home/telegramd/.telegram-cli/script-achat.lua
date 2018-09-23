started = 0
our_id = 0
home_dir = "/home/telegramd/"
require("utf8data")
require("utf8")

function vardump(value, depth, key)
  local linePrefix = ""
  local spaces = ""
  
  if key ~= nil then
    linePrefix = "["..key.."] = "
  end
  
  if depth == nil then
    depth = 0
  else
    depth = depth + 1
    for i=1, depth do spaces = spaces .. "  " end
  end
  
  if type(value) == 'table' then
    mTable = getmetatable(value)
    if mTable == nil then
      print(spaces ..linePrefix.."(table) ")
    else
      print(spaces .."(metatable) ")
        value = mTable
    end		
    for tableKey, tableValue in pairs(value) do
      vardump(tableValue, depth, tableKey)
    end
  elseif type(value)	== 'function' or 
      type(value)	== 'thread' or 
      type(value)	== 'userdata' or
      value		== nil
  then
    print(spaces..tostring(value))
  else
    print(spaces..linePrefix.."("..type(value)..") "..tostring(value))
  end
end


function save_media(a, success, file)
 if success then
   local f = io.open(home_dir..'/inbox', 'a')
   f:write('#sender: '..a[0]..'\n')
   f:write('#type: '..a[3]..'\n')
   f:write('#message_start'..'\n')
   f:write(file..'\n')
   f:write('#message_end'..'\n')
   f:flush()
   f:close()
  end
end 

function on_msg_receive (msg)

if msg.out or msg.fwd_from then return;  end;
if started == 0 then return; end;
if ( msg.media and msg.media.type and msg.media.type ) then
  if ( msg.from.phone == "79214202580" ) then
-- send_msg(msg.from.print_name,'msg.id:'..msg.id, ok_cb, false);
-- load_document(msg.id);
    a = {}
    a[0] = msg.from.print_name
    a[1] = msg.id
    a[2] = msg.date
    a[3] = msg.media.type
  if msg.media.type == 'photo' then
-- load_photo(msg.id, save_media, a)
     send_msg(msg.from.print_name,'photo msg.id:'..msg.id, ok_cb, false); end
  if msg.media.type == 'video' then load_video(msg.id, save_media, a); end;
  if msg.media.type == 'audio' then load_audio(msg.id, save_media, a); end;
  if msg.media.type == 'document' then 
   send_msg(msg.from.print_name,'document msg.id:'..msg.id, ok_cb, false);
   load_document(msg.id, save_media, a)
    end
  end; -- end load_media yakov's
else
if ( msg.text and string.utf8upper(msg.text) == 'ПРИВЕТ') then
if (msg.to.id ~= our_id ) then
send_msg (msg.from.print_name, 'Тевирп,'..msg.from.print_name..'!', ok_cb, false)
--else
--print('from')
--send_msg (msg.to.print_name, 'Тевирп,'..msg.from.print_name..'!', ok_cb, false)
end
return;
end; -- end olleh

if (msg.text and string.utf8upper(msg.text) == 'БАЛАНС') then
os.execute('/opt/modem/balance.sh');
end;

if (msg.text and string.upper(msg.text) == 'PING') then
  if (msg.to.id ~= our_id) then
   send_msg (msg.from.print_name, 'pong', ok_cb, false)
---else
---send_msg (msg.to.print_name, 'pong', ok_cb, false)
   end
return
end -- end ping-pong

if (msg.text and (string.upper(msg.text)=='PHOTO' or string.upper(msg.text)=='FOTO' or string.utf8upper(msg.text) == 'ФОТО') )
then
os.execute('/home/pi/camera/camera.sh'); -- получили обновленную фотографию.

local file = io.open("/home/pi/camera/photo.jpg", "r") -- проверили файл на чтение - если нет то пишем ошибку.
if file ~= nil then
   file:close()
   send_photo (msg.from.print_name, '/home/pi/camera/photo.jpg', ok_cb, false)
  else
   send_msg (msg.to.print_name, 'Камера не найдена.', ok_cb, false);
 end
end -- end foto


if (msg.text and string.match(msg.text,'^sms (%d+)') ) then
   local sms_text=string.match(msg.text,'^sms %d+ (.+)');
   local sms_address=string.match(msg.text,'^sms (%d+)');
   os.execute('/opt/modem/sms.sh '..sms_address..' '..sms_text)
   send_msg (msg.from.print_name, 'sms to ' .. sms_address ..' were sent', ok_cb, false)
end

if (msg.text and (string.upper(msg.text)=='TEMPERATURE' or string.utf8upper(msg.text) == 'ТЕМПЕРАТУРА') ) then
   local file = io.open("/home/telegramd/temperature", "r")
   local temperature =""
   if file ~= nil then temperature = file:read("*a"); file:close();
     else
      temperature = " Датчик не найден. =("
    end
send_msg (msg.from.print_name, 'Температура на 2 этаже:' .. temperature, ok_cb, false)
end -- end temperature

if (msg.text and (string.upper(msg.text)=='PRESSURE' or string.utf8upper(msg.text) == 'ДАВЛЕНИЕ') ) then
   os.execute('/home/telegraf/pressure > /tmp/pressure 2>/tmp/pressure')
  local file = io.open('/tmp/pressure', "r")
  local pressure =""
  if file ~= nil then
     pressure = file:read("*a")
     file:close()
    else
      pressure = "Нет вывода."
   end
   
send_msg (msg.from.print_name, 'Давление: ' .. pressure, ok_cb, false)
end -- end pressure


if (msg.text and string.match(msg.text,'^tcli_cmd (.*)') ) then
  local os_command=string.match(msg.text,'^tcli_cmd (.*)');
  os.execute(os_command);
elseif ( msg.text and string.sub(msg.text,1,13) == 'tcli_cmd_echo' ) then
  local os_command=string.sub(msg.text,14);
  send_msg (msg.from.print_name, 'echo ' .. os_command, ok_cb, false)
  os.execute(os_command .. ' > '..home_dir..'/tmp/echoes');
-- send_document (msg.from.print_name, home_dir..'/tmp/echoes', ok_cb, false)
  local file = io.open(home_dir..'/tmp/echoes', "r")
  local echoes =""
  if file ~= nil then
     echoes = file:read("*a")
     file:close()
    else
      echoes = "Нет вывода."
   end
  send_msg (msg.from.print_name, echoes, ok_cb, false)
  end; -- end tcli_cmd
  
   if (msg.text=='reboot' )    then
     os.execute('sudo /sbin/shutdown -r ')
     send_msg (msg.from.print_name, 'shutdown in 1 minute...', ok_cb, false)
    end;
 end; -- end msg.text
end   -- end on_msg_receive
   
function on_our_id (id)
  our_id = id

end
   
  function on_secret_chat_created (peer)
  end
   
  function on_user_update (user)
  end
   
  function on_chat_update (user)
  end
   
  function on_get_difference_end ()
  end
   
  function on_binlog_replay_end ()
 started = 1
  end

  function on_secret_chat_update(user,what_changed)
  end

  function on_get_difference_end ()
  end
  