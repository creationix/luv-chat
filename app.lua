local p = require('utils').prettyPrint
local app = require('moonslice')()
local await = require('fiber').await

-- A custom endpoint
app:get("^/greet$", function (req, res)
  res(200, {}, "Hello World\n")
end)

-- A websocket echo endpoint
app:websocket("^/socket$", function (headers, socket)
  repeat
    local message = await(socket.read())
    if message then
      socket.write("Hello " .. message)()
    end
  until not message
  socket.write()()
end)

-- Serve a folder as static resources
app:static("public")

app.log = true

p(app)

return app
