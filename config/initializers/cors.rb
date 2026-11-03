# la pagina personal lee el price list desde otro origen.
# solo se abre /api/v1/services (GET), que es publico y no pide token.
# /api/v1/repairs y el POST de services no se abren a ningun origen.
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://cvbustamante.github.io", "http://localhost:5500"

    resource "/api/v1/services*",
      headers: :any,
      methods: [:get]
  end
end
