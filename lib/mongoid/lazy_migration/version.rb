module Mongoid
  module LazyMigration
    base = "0.8.2"

  # SB-specific versioning "algorithm" to accommodate BNW/Jenkins/gemstash
    VERSION = (pre = ENV.fetch('GEM_PRE_RELEASE', '')).empty? ? base : "#{base}.#{pre}"
  end
end
