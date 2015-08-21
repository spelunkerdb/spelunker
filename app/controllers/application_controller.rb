class ApplicationController < ActionController::Base
  DEFAULT_TARGET      = '6.x'
  SITE_PROTOCOL       = 'https'
  DEFAULT_SUBDOMAIN   = 'www'
  SITE_DOMAIN         = 'spelunkerdb.com'
  SITE_PORT           = ''

  protect_from_forgery with: :exception

  helper_method :page, :current_target, :targeted_url, :api_url

  def page
    @page ||= {}
  end

  def current_target
    Target.where(slug: resolve_target).first
  end

  def untargeted_path(path)
    # Not a targeted path.
    return path if (path =~ /\/v\/\d.+/).nil?

    untargeted_path = path.to_s.dup
    untargeted_path.gsub!(/(\/v\/.+?\/)/, '/')

    untargeted_path
  end

  def targeted_path(path)
    target_slug = resolve_target
    target_type = parse_target_type(target_slug)
    use_prefix  = true

    # If the site was accessed at www and the era-level target was specified, keep the subdomain
    # at www and exclude the /v/ portion of the targeted path. This covers a basic browsing
    # scenario, in which the user isn't interested in locking the view to a specific target.
    # Otherwise, ensure the subdomain matches the client era of the target.
    if target_slug == DEFAULT_TARGET && request.subdomain == DEFAULT_SUBDOMAIN
      subdomain = DEFAULT_SUBDOMAIN
      use_prefix = false
    elsif target_type == :era
      subdomain = ClientEra.where(slug: target_slug).first.subdomain
      prefix = "/v/#{target_slug}"
    elsif target_type == :version
      subdomain = ClientVersion.where(slug: target_slug).first.era.subdomain
      prefix = "/v/#{target_slug}"
    elsif target_type == :patch
      subdomain = ClientPatch.where(slug: target_slug).first.era.subdomain
      prefix = "/v/#{target_slug}"
    elsif target_type == :build
      subdomain = ClientBuild.where(slug: target_slug).first.era.subdomain
      prefix = "/v/#{target_slug}"
    end

    url = ''
    url << prefix if use_prefix == true
    url << path
    url
  end

  def targeted_url(path)
    target_slug = resolve_target
    target_type = parse_target_type(target_slug)

    if target_slug == DEFAULT_TARGET && request.subdomain == DEFAULT_SUBDOMAIN
      subdomain = 'www'
    elsif target_type == :era
      subdomain = ClientEra.where(slug: target_slug).first.subdomain
    elsif target_type == :version
      subdomain = ClientVersion.where(slug: target_slug).first.era.subdomain
    elsif target_type == :build
      subdomain = ClientBuild.where(slug: target_slug).first.era.subdomain
    end

    url = "#{SITE_PROTOCOL}://#{subdomain}.#{SITE_DOMAIN}#{SITE_PORT}"
    url << targeted_path(path)
    url
  end

  def api_url(path)
    #url = "#{SITE_PROTOCOL}://#{DEFAULT_SUBDOMAIN}.#{SITE_DOMAIN}#{SITE_PORT}"
    url = ''
    url << '/api'
    url << targeted_path(path)
    url
  end

  private def resolve_target
    # No session target results in default target.
    if session[:target].nil?
      session[:target] = DEFAULT_TARGET
    end

    # URL trumps session.
    if params.has_key?(:target) && session[:target] != params[:target]
      session[:target] = params[:target]
    end

    session[:target]
  end

  # Examples:
  # - era: 6.x
  # - version: 6.2.x
  # - patch: 6.2.0.x
  # - build: 6.2.0.20338
  private def parse_target_type(target_slug)
    segments = target_slug.split('.')

    return :build   if segments.last != 'x'
    return :patch   if segments.length == 4
    return :version if segments.length == 3
    return :era     if segments.length == 2

    # If we got this far, the slug was wrong.
    raise 'Invalid URL'
  end

  private def targeted_build
    target_slug = resolve_target
    target_type = parse_target_type(target_slug)

    segments = target_slug.split('.')

    case target_type
    when :build
      build = ClientBuild.where(slug: target_slug).first
    when :patch
      patch = ClientPatch.where(slug: target_slug).first
      build = patch.current_build
    when :version
      version = ClientVersion.where(slug: target_slug).first
      build = version.current_build
    when :era
      era = ClientVersion.where(slug: target_slug).first
      build = era.current_build
    end

    build
  end
end
