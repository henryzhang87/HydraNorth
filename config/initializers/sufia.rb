# Returns an array containing the vhost 'CoSign service' value and URL
Sufia.config do |config|

  config.fits_to_desc_mapping= {
    file_title: :title,
    file_author: :creator
  }

  # Specify a different template for your repositories unique identifiers
  # config.noid_template = ".reeddeeddk"

  config.max_days_between_audits = 7

  config.max_notifications_for_dashboard = 5

  config.cc_licenses = {
    'Attribution 4.0 International' => 'http://creativecommons.org/licenses/by/4.0/',
    'Attribution-ShareAlike 4.0 International' => 'http://creativecommons.org/licenses/by-sa/4.0/',
    'Attribution-NonCommercial 4.0 International' => 'http://creativecommons.org/licenses/by-nc/4.0/',
    'Attribution-NoDerivs 4.0 International' => 'http://creativecommons.org/licenses/by-nd/4.0/',
    'Attribution-NonCommercial-NoDerivs 4.0 International' => 'http://creativecommons.org/licenses/by-nc-nd/4.0/',
    'Attribution-NonCommercial-ShareAlike 4.0 International' => 'http://creativecommons.org/licenses/by-nc-sa/4.0/',
    'Public Domain Mark 1.0' => 'http://creativecommons.org/publicdomain/mark/1.0/',
    'CC0 1.0 Universal' => 'http://creativecommons.org/publicdomain/zero/1.0/',
    'All rights reserved' => 'All rights reserved'
  }

  config.cc_licenses_reverse = Hash[*config.cc_licenses.to_a.flatten.reverse]

  config.resource_types = {
    "Book" => "Book",
    "Book Chapter" => "Book Chapter",
    "Computing Science Technical Report" => "Computing Science Technical Report",
    "Conference\/Workshop Poster" => "Conference\/Workshop Poster",
    "Conference\/Workshop Presentation" => "Conference\/Workshop Presentation",
    "Image" => "Image",
    "Journal Article (Draft-Submitted)" => "Journal Article (Draft-Submitted)",
    "Journal Article (Published)" => "Journal Article (Published)",
    "Learning Object" => "Learning Object",
    "Map or Cartographic Material" => "Map or Cartographic Material",
    "Report" => "Report",
    "Research Material" => "Research Material",
    "Review" => "Review",
    "Structural Engineering Report" => "Structural Engineering Report",
    "Thesis" => "Thesis",
  }

  config.resource_types_to_schema = {
    "Book" => "http://schema.org/Book",
    "Book Chapter" => "http://schema.org/Book",
    "Computing Science Technical Report" => "http://schema.org/CreativeWork",
    "Conference\/Workshop Poster" => "http://schema.org/CreativeWork",
    "Conference\/Workshop Presentation" => "http://schema.org/CreativeWork",
    "Image" => "http://schema.org/ImageObject",
    "Journal Article (Draft-Submitted)" => "http://schema.org/Article",
    "Journal Article (Published)" => "http://schema.org/Article",
    "Learning Object" => "http://schema.org/CreativeWork",
    "Map or Cartographic Material" => "http://schema.org/Map",
    "Report" => "http://schema.org/CreativeWork",
    "Research Material" => "http://schema.org/CreativeWork",
    "Review" => "http://schema.org/Review",
    "Structural Engineering Report" => "http://schema.org/CreativeWork",
    "Thesis" => "http://schema.org/CreativeWork",
  }

  config.permission_levels = {
    "Choose Access"=>"none",
    "View/Download" => "read",
    "Edit" => "edit"
  }

  config.owner_permission_levels = {
    "Edit" => "edit"
  }
  config.cstr_collection_id = "9a9ca13a-eeba-431a-8782-8ce1bd64e6e5"
  config.ser_collection_id = "5e43a8f1-e3e4-452a-82c9-cf8040686db6" 

  config.queue = Sufia::Resque::Queue

  # Enable displaying usage statistics in the UI
  # Defaults to FALSE
  # Requires a Google Analytics id and OAuth2 keyfile.  See README for more info
  config.analytics = false

  # Specify a Google Analytics tracking ID to gather usage statistics
  # config.google_analytics_id = 'UA-99999999-1'

  # Specify a date you wish to start collecting Google Analytic statistics for.
  # config.analytic_start_date = DateTime.new(2014,9,10)

  # Where to store tempfiles, leave blank for the system temp directory (e.g. /tmp)
  # config.temp_file_base = '/home/developer1'

  # If you have ffmpeg installed and want to transcode audio and video uncomment this line
  # config.enable_ffmpeg = true

  # Specify the Fedora pid prefix:
  # config.id_namespace = "sufia"

  # Specify the path to the file characterization tool:
  # config.fits_path = "fits.sh"
   config.fits_path = "/usr/local/bin/fits-0.6.2/fits.sh"

  # Specify how many seconds back from the current time that we should show by default of the user's activity on the user's dashboard
  # config.activity_to_show_default_seconds_since_now = 24*60*60

  # Specify a date you wish to start collecting Google Analytic statistics for.
  # Leaving it blank will set the start date to when ever the file was uploaded by
  # NOTE: if you have always sent analytics to GA for downloads and page views leave this commented out
  # config.analytic_start_date = DateTime.new(2014,9,10)
  #
  # Method of converting pids into URIs for storage in Fedora
  # config.translate_uri_to_id = lambda { |uri| uri.to_s.split('/')[-1] }
  # config.translate_id_to_uri = lambda { |id|
  #      "#{ActiveFedora.fedora.host}#{ActiveFedora.fedora.base_path}/#{Sufia::Noid.treeify(id)}" }

  # If browse-everything has been configured, load the configs.  Otherwise, set to nil.
  begin
    if defined? BrowseEverything
      config.browse_everything = BrowseEverything.config
    else
      Rails.logger.warn "BrowseEverything is not installed"
    end
  rescue Errno::ENOENT
    config.browse_everything = nil
  end

end

Date::DATE_FORMATS[:standard] = "%m/%d/%Y"
