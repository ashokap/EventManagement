CarrierWave.configure do |config|
  #config when using aws sdk
  config.storage    = :aws
  config.aws_bucket = 'panabucket'
  config.aws_acl    = :public_read
 # config.asset_host = 's3.amazonaws.com'
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

  config.aws_credentials = {
    access_key_id:     'AKIAIAAYVBD5RLNACTLQ',
    secret_access_key: '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'
  }
  
  #Config when using fog
  # config.fog_credentials = {
    # :provider               => 'AWS',                        # required
    # :aws_access_key_id      => 'AKIAJIYMBQJ6HQXUT6OQ',       # required
    # :aws_secret_access_key  => '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',                        # required
    # # :region                 => 'eu-west-1',                  # optional, defaults to 'us-east-1'
    # # :host                   => 's3.example.com',             # optional, defaults to nil
    # # :endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
  # }
  # config.fog_directory  = 'panabucket'                          # required
  # # config.fog_public     = false                                        # optional, defaults to true
  # # config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"} # optional, defaults to {}
  # config.cache_dir = "#{Rails.root}/tmp/uploads"
end