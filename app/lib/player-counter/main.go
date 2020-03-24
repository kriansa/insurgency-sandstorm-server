/**
 * Simple CLI that returns the amount of players connected to a server by using the steam server
 * query protocol.
 *
 * Usage: $0 [<IP>] [<PORT>]
 *
 * If you don't pass the parameters, the defaults are assumed: IP 127.0.0.1 and Port 27131
 */

package main

import (
  "os"
  "fmt"
  a2s "github.com/rumblefrog/go-a2s"
)

func main() {
  count, err := getPlayerCount()

  if err != nil {
    fmt.Println(err)
    os.Exit(1)
  }

  fmt.Println(count)
}

func getPlayerCount() (uint8, error) {
  var ip string
  var port string

  switch len(os.Args) {
  case 1:
    ip = "127.0.0.1"
    port = "27131"
  case 2: 
    ip = os.Args[1]
    port = "27131"
  case 3:
    ip = os.Args[1]
    port = os.Args[2]
  }

  count, err := getPlayerCountOnServer(ip, port)
  if err != nil { return 0, err }

  return count, nil
}

func getPlayerCountOnServer(ip string, port string) (uint8, error) {
  client, err := a2s.NewClient(fmt.Sprintf("%s:%s", ip, port))
  if client != nil { defer client.Close() }
  if err != nil { return 0, err }

  info, err := client.QueryInfo()
  if err != nil { return 0, err }

  return info.Players, nil
}
