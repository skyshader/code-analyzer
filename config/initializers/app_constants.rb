# Application specific configurations
# In form of:
# Analyzer::Application.config.x.<KEY_NAME> = <VALUE_NAME>

# Initializers for development environment
if Rails.env.development?
	Analyzer::Application.config.x.notify_url = 'http://vp.com/site/analyzerStatus'
end

# Initializers for test environment
if Rails.env.test?
	Analyzer::Application.config.x.notify_url = 'http://example.com/test'
end

# Initializers for staging environment
if Rails.env.staging?
	Analyzer::Application.config.x.notify_url = 'http://dev1.venturepact.com/site/analyzerStatus'
end

# Initializers for production environment
if Rails.env.production?
	Analyzer::Application.config.x.notify_url = 'http://example.com/production'
end
