import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :benvp, BenvpWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "sU4hGWUUzVlXMndCCxT+rBlvSkJMIoHRy2YNGUProWgCJLLUMM+fm4zkiooqdsJS",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
