I18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}").to_s]
I18n.available_locales = %i(ja vi)
I18n.default_locale = :vi
I18n.enforce_available_locales = true
