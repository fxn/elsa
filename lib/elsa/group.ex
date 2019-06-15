defmodule Elsa.Group do

  import Elsa.Util, only: [with_connection: 2, get_api_version: 2]
  import Record, only: [defrecord: 2, extract: 2]

  defrecord :kpro_rsp, extract(:kpro_rsp, from_lib: "kafka_protocol/include/kpro.hrl")

  def list(endpoints) do
    with_connection(endpoints, fn connection ->
      version = get_api_version(connection, :list_groups)
      request = :kpro_req_lib.make(:list_groups, version, %{})

      {:ok, response} = :kpro.request_sync(connection, request, 5_000)
      kpro_rsp(response, :msg).groups
      |> Enum.map(fn grp -> grp.group_id end)
    end)
  end

  def describe(endpoints, group) do
    with_connection(endpoints, fn connection ->
      version = get_api_version(connection, :describe_groups)
      request = :kpro_req_lib.make(:describe_groups, version, %{group_ids: [group]})

      {:ok, response} = :kpro.request_sync(connection, request, 5_000)
      kpro_rsp(response, :msg)
    end)
  end

end
