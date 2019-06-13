defmodule Elsa do
  @moduledoc """
  Documentation for Elsa.
  """

  import Record

  defrecord :kafka_message, extract(:kafka_message, from_lib: "kafka_protocol/include/kpro_public.hrl")

  defdelegate list_topics(endpoints), to: Elsa.Topic, as: :list

  defdelegate create_topic(endpoints, topic, opts \\ []), to: Elsa.Topic, as: :create

  defdelegate delete_topic(endpoints, topic), to: Elsa.Topic, as: :delete

  defdelegate produce_sync(endpoints, topic, partition, key, value), to: Elsa.Producer, as: :produce_sync

  defdelegate list_groups(endpoints), to: Elsa.Group, as: :list

  def default_client(), do: :elsa_default_client

  defmodule ConnectError do
    defexception [:message]
  end
end
