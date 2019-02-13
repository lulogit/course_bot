defmodule Bstruct do
  defstruct convo: nil, convs: nil, curr_state: nil, curr_says: nil, curr_conv: nil, curr_conv_states: nil
end

defmodule Coursebot.Botpiler do
  import Earmark, only: [as_html!: 1]
  import Poison, only: [encode!: 1]
  import UUID, only: [uuid4: 0]

  defp parse(l,bot_state) do
    case String.first(l) do
      "[" -> conversation(Regex.run(~r/^\[([a-zA-Z0-9 ]+)\]$/, l, capture: :all_but_first), bot_state)
      "#" -> reference(Regex.run(~r/^#([a-zA-Z0-9 ]+)\/(\d+)$/, l, capture: :all_but_first), bot_state)
      "b" -> say(String.trim_leading(l,"b: "), bot_state)
      "u" -> question(String.trim_leading(l,"u: "), bot_state)
      true -> bot_state
    end
  end

  defp conversation([name],bs) do
    put_in(bs.convs[bs.curr_conv], Enum.reverse(bs.curr_conv_states))
    |> Map.put(:curr_conv, name)
    |> Map.put(:curr_conv_states, [])
  end

  defp reference([name,interaction],bs) do
    ref_state = Enum.at(bs.convs[name], String.to_integer(interaction), "ice")
    bs
    |> Map.put(:curr_state, ref_state)
    |> Map.put(:curr_conv_states, [ref_state])
    |> Map.put(:ref?, true)
  end

  defp say(markdown,bot_state) do
    msg = as_html!(markdown)
    bot_state
    |> Map.update(:curr_says,[],&([msg|&1])) # append message
  end

  defp question(question,bs) do
    new_id = uuid4()
    closed_state = case Map.has_key?(bs.convo,bs.curr_state) do
      false -> new_state(bs.curr_says,question,new_id)
      true  -> add_question(bs.convo[bs.curr_state],question,new_id)
    end
    put_in(bs.convo[bs.curr_state],closed_state)
    |> Map.put(:curr_says, [])
    |> Map.update(:curr_conv_states,[],&([bs.curr_state|&1]))
    |> Map.put(:curr_state, new_id)
  end
 
  defp new_state(says, question, answer) do
    %{"says" => Enum.reverse(says),"reply" => [%{"question"=>question,"answer"=>answer}]}
  end

  defp add_question(state,question,answer) do
    state
    |> Map.update("reply", [], &([%{"question"=>question,"answer"=>answer}|&1]))
  end

  defp init() do
    %Bstruct{convo: %{}, convs: %{}, curr_state: "ice", curr_says: [], curr_conv: nil, curr_conv_states: []}
  end

  defp get_convo(bs) do
    bs.convo
    |> Map.put(bs.curr_state, %{"says"=>Enum.reverse(bs.curr_says), "reply"=>[]})
  end

  def as_convo(filename) do
    File.stream!(filename)
    |> Stream.filter(&(&1!="\n"))
    |> Stream.map(&(String.trim_trailing(&1,"\n")))
    |> Enum.reduce(init(),&parse/2)
    |> get_convo()
    |> encode!()
  end
end
