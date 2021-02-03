local host, port = "localhost", 65367
local socket = require("socket")
local tcp = assert(socket.tcp())
tcp:settimeout(2)
asdf = tcp:connect(host, port);

print(asdf)

--note the newline below
tcp:send("hello world\n");

-- while true do
--    local s, status, partial = tcp:receive()
--    print(s or partial)
--    if status == "closed" then break end
--end
tcp:close()