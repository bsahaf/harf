# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :discuss,
  ecto_repos: [Discuss.Repo]

# Configures the endpoint
config :discuss, Discuss.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/EugnDO18NS1LOfBiMRZcpSiYGzHHHr8+jGzrWG98oNrJ28A5xHshPWyHfX+ngdp",
  render_errors: [view: Discuss.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Discuss.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"


config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user,public_repo"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "7b7453525497064960b9",
  client_secret: "f913e3e9b7e1fd26d30579f69a638e105cac27ab"


  config :ex_aws, 
    access_key_id: "AKIA4ELU2BNRMMOGUBPE",
    secret_access_key: "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",
    s3: [ 
      scheme: "https://", 
      host: "basim-image-storage-bucket.s3-us-west-2.amazonaws.com", 
      region: "us-west-2" 
    ]
