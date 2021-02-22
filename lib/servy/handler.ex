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
    %{method: method, path: path, resp_body: "", status: nil}
  end

  def route(conv) do
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/wildthings") do
    %{conv | status: 200, resp_body: "Bears, Liöns, Tigers"}
  end

  def route(conv, "GET", "/bears") do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(conv, "GET", "/bears/" <> id) do
    %{conv | status: 200, resp_body: "Bears #{id}"}
  end

  def route(conv, "DELETE", "/bears/" <> _id) do
    %{conv | status: 200, resp_body: "Deleting a bear is forbidden"}
  end

  def route(conv, _method, path) do
    %{conv | status: 404, resp_body: "No #{path} Here!"}
  end

  def format_response(conv) do
    # Use values in the map to create an HTTP response string
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}
    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
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

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bears/10 HTTP/1.1
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
