defmodule Auth.Guardian do
  @moduledoc """
  Integration with Guardian
  """
  use Guardian, otp_app: :auth

  use Guardian.Permissions.Bitwise

  def subject_for_token(%{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def subject_for_token(_, _) do
    {:error, :no_resource_id}
  end

  def resource_from_claims(%{"sub" => sub}) do
    {:ok, Auth.Accounts.get_user!(sub)}
  end

  def resource_from_claims(_claims) do
    {:error, :no_claims_sub}
  end

  def build_claims(claims, _resource, opts) do
    claims =
      claims
      |> encode_permissions_into_claims!(Keyword.get(opts, :permissions))

    {:ok, claims}
  end
end
