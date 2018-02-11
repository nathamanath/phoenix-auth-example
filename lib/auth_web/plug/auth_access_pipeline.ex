defmodule OneplaceWeb.Plug.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :auth

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated

  # This one is optional, it means you can use
  # ` Guardian.Plug.current_resource(conn)` to get your current user
  plug Guardian.Plug.LoadResource, ensure: true
end
