ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(TheRush.Repo, :manual)

# Mocks
Mox.defmock(TheRush.MockFiles, for: TheRush.Files)

# Mocks modules
Application.put_env(:the_rush, :files_module, TheRush.MockFiles)
