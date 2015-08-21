module TargetUtilities
  def self.target_for(slug, opts = {})
    target = Target.where(slug: slug).first
    return nil if target.nil?

    case opts[:entry_type]
    when :static
      return target.current
    when :sourced
      return target
    else
      return nil
    end
  end
end
