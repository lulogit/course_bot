# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CourseBot.Repo.insert!(%CourseBot.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


CourseBot.Repo.insert!(%CourseBot.Chatbots.Bot{name: "a bot", description: "very cool !"})
