defmodule Servy.FilHandler do
  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "File not found!"}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end

  # def route(%{method: "GET", path: "/about"} = conv) do
  #   file =
  #     Path.expand("../../pages", __DIR__)
  #     |> Path.join("about.html")

  #   case File.read(file) do
  #     {:ok, content} ->
  #       %{ conv | status: 200, resp_body: content }

  #     {:error, :enoent} ->
  #       %{ conv | status: 404, resp_body: "File not found!" }

  #     {:error, reason} ->
  #       %{ conv | status: 500, resp_body: "File error: #{reason}" }
  #   end
  # end
end
