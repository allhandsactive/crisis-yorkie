module NavHelper
  def nav_link stem, action_stem
    action_stem.nil? and stem = "#{stem}s" # blegh
    send [action_stem, stem, 'path'].compact.join('_')
  end
end
