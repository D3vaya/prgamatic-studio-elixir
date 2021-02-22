defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse()
    |> log()
    |> route()
    |> format_response()
  end

  def log(conv), do: IO.inspect(conv)

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    # Parse the request string into a map
    %{method: method, path: path, resp_body: ""}
  end

  def route(conv) do
    route(conv, conv.path)
  end

  def route(conv, "/wildthings") do
    %{conv | resp_body: "Bears, Liöns, Tigers"}
  end

  def route(conv, "/bears") do
    %{conv | resp_body: "Teddy, Smokey, Paddington"}
  end

  def format_response(conv) do
    # Use values in the map to create an HTTP response string
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}
    #{conv.resp_body}
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

expected_response = """
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 20

Bears, Lions, Tigers

"""

request = """
GET /bigdoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

expected_response = """
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 20

Teddy, Smokey, Paddington

"""

response = Servy.Handler.handle(request)
IO.puts(response)
