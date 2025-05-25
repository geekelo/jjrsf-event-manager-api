Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins [
    'http://localhost:3000',
    'http://localhost:5173',
    'https://jjrsf-event-manager-admin.vercel.app',
    'https://jjrsf-event-manager-guest.vercel.app',
    # 'https://programsportal.jjrsf.org',
    # 'https://programs.jjrsf.org',
  ] # Add your frontend origin(s)

    resource '/api/*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end
