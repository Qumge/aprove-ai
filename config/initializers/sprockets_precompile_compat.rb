Rails.application.config.after_initialize do
  if Rails.application.config.respond_to?(:assets)
    Rails.application.config.assets.precompile.delete_if { |asset| asset.is_a?(Regexp) }
  end
end
