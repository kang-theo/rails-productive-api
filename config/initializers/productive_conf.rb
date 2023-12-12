# PRODUCTIVE_CONF = YAML.load_file("#{Rails.root}/config/productive_conf.yml")[Rails.env]
PRODUCTIVE_CONF = YAML.load(ERB.new(File.read("#{Rails.root}/config/productive_conf.yml")).result)[Rails.env]
