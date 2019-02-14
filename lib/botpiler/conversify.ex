defmodule CourseBot.Botpiler.Conversify do
  import Poison, only: [decode!: 1]
  import HtmlSanitizeEx, only: [strip_tags: 1]

  def as_text(convo_str) do
    convo_str
    |> decode!()
    |> reconstruct()
  end

  defp as_markdown(html) do
    a = Regex.replace(~r/<img src=\"([^\"]+)\"[^\/]*\/>/, html, "![](\\1)")
    b = Regex.replace(~r/<a href=\"([^\"]+)\"[^>]*>([^<]*)<\/a>/, a, "[\\2](\\1)")
    strip_tags(b)
  end

  defp reconstruct(convo) do
    reconstr_acc(convo,[{:continue, "ice"}],"[main]", "main", 0)
  end

  defp reconstr_acc(_, [], text, _,_) do
    text
  end

  defp reconstr_acc(convo, [{conv,state}|rest], text, c,i)  do
    cond do
      not Map.has_key?(convo, state) -> reconstr_acc(convo,rest,text,c,i)
      true -> 
        s = convo[state]
        says = s["says"]
               |> Enum.map(&as_markdown/1)
               |> Enum.map(&("b: " <> &1)) 
               |> Enum.join("\n")
        {reply,frontier2} = case s["reply"] do
          [] -> {"",[]}
          [r|rs] -> {"u: " <> r["question"], [{:continue,r["answer"]}]++Enum.map(rs, &({{c,i,Map.get(&1,"question")},Map.get(&1,"answer")}))}
        end
        text2 = case conv do
          :continue -> "#{text}\n#{says}\n#{reply}"
          {cc,ii,name} -> "#{text}\n[#{name}]\n##{cc}/#{ii}\n#{says}\n#{reply}"
        end
        {c2,i2} = case rest do
          [{:continue,_}|_] -> {c,i+1}
          [{{_,_,name},_}|_] -> {name,0}
          [] -> {c,i+1}
        end
        reconstr_acc(convo, frontier2++rest,text2, c2,i2)
    end
  end

end
