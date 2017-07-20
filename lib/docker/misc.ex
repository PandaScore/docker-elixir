defmodule Docker.Misc do
  @doc """
  Display system-wide information.
  """
  def info do
    Docker.Client.get("/info") |> decode_system_response
  end

  @doc """
  Show the docker version information.
  """
  def version do
    Docker.Client.get("/version") |> decode_system_response
  end

  defp decode_system_response(%HTTPoison.Response{body: body, status_code: status_code}) do
    # Logger.debug "Decoding Docker API response: #{inspect body}"
    case Poison.decode(body) do
      {:ok, dict} ->
        case status_code do
          200 -> {:ok, dict}
          500 -> {:error, "Server error"}
        end
      {:error, message} ->
        {:error, message}
    end
  end

  @doc """
  Ping the docker server.
  """
  def ping do
    Docker.Client.get("/_ping") |> decode_ping_response
  end

  defp decode_ping_response(%HTTPoison.Response{body: body, status_code: status_code}) do
    case status_code do
      200 -> {:ok, body}
      500 -> {:error, "Server error"}
    end
  end

  @doc """
  Monitor Docker's events since given timestamp.
  """
  def events(since), do: Docker.Client.get("/events?since=#{since}")
  
  @doc """
  Monitor Docker's events as stream.
  """
  def events_stream, do: Docker.Client.stream(:get, "/events")
  def events_stream(filter) do
    json = filter |> Poison.encode!
    Docker.Client.stream(:get, "/events?filters=#{json}")
  end

  # @doc """
  # Return real-time events from server as a stream.
  # """
  # def stream_events do
  #   stream = Stream.resource(
  #     fn -> start_streaming_events("/events") end,
  #     fn status -> receive_events(status) end,
  #     fn _ -> end
  #   )
  #   {:ok, stream}
  # end

  # defp start_streaming_events(url) do
  #   Docker.Client.stream(:get, url)
  #   :streaming
  # end

  # defp receive_events(:streamed) do
  #   {:halt, nil}
  # end
  # defp receive_events(:streaming) do
  #   receive do
  #     %HTTPoison.AsyncStatus{id: _id, code: code} ->
  #       case code do
  #         200 -> {[{:status, {:ok}}], :streaming}
  #         404 -> {[{:status, {:error, "Repository does not exist or no read access"}}], :streamed}
  #         500 -> {[{:status, {:error, "Server error"}}], :streamed}
  #       end
  #     %HTTPoison.AsyncHeaders{id: _id, headers: _headers} ->
  #       {[{:headers}], :streaming}
  #     %HTTPoison.AsyncChunk{id: _id, chunk: _chunk} ->
  #       {[{:chunk}], :streaming}
  #     %HTTPoison.AsyncEnd{id: _id} ->
  #       {[{:end}], :streamed}
  #   end
  # end
end
