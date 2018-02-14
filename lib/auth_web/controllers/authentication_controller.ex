defmodule AuthWeb.AuthenticationController do
  @moduledoc """
  Handle authentication requests and oauth2 callbacks
  """
  use AuthWeb, :controller

  alias Auth.Accounts

  plug Ueberauth

  @doc """
  Ueberauth identity (email / password) authentication callback
  """
  def identity_callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    username = auth.uid
    password = auth.credentials.other.password

    handle_user_conn(Accounts.get_user_by_username_and_password(username, password), conn)
  end

  # handle conn for callbacks above
  defp handle_user_conn(user, conn) do
    case user do
      {:ok, user} ->
        {:ok, jwt, _full_claims} =
          Auth.Guardian.encode_and_sign(user, %{}, permissions: user.permissions)

        conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> json(%{token: jwt})

      # Handle our own error to keep it generic
      {:error, _reason} ->
        conn
        |> put_status(401)
        |> json(%{message: "user not found"})
    end
  end
end
