module Helper exposing (message)

import Task

message : msg -> Cmd msg
message msg =
  Task.perform identity identity <| Task.succeed msg