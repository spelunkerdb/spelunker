class Target < ActiveRecord::Base
  belongs_to  :current,     class_name: 'Target', foreign_key: 'current_target_id'
  has_many    :aggregates,  class_name: 'TargetAggregate'

  # Ensure all eras, versions, patches, and builds are fully represented as targets.
  def self.sync!
    Target.transaction do
      [ClientEra, ClientVersion, ClientPatch, ClientBuild].each do |level|
        level.order('id ASC').all.each do |level_target|
          sync_level!(level_target)
        end
      end

      sync_current!
      sync_aggregates!
    end
  end

  def self.sync_current!
    Target.all.each do |target|
      level = target.fetch_level

      next if level.current_build.nil?

      target.current = Target.where(slug: level.current_build.slug).first

      target.save!
    end
  end

  def self.sync_aggregates!
    Target.all.each do |target|
      level = target.fetch_level

      level.builds.each do |build|
        aggregated_target = Target.where(slug: build.slug).first
        next if aggregated_target.nil?

        if !target.aggregates.where(aggregated_target_id: aggregated_target.id).exists?
          target_aggregate = target.aggregates.new
          target_aggregate.aggregated_target = aggregated_target
          target_aggregate.save!
        end
      end
    end
  end

  def self.sync_level!(level)
    target = Target.where(slug: level.slug).first

    if target.nil?
      target = Target.new
      target.slug = level.slug
    end

    target.level = level.class.name.underscore

    target.save!
  end

  def level
    fetch_level
  end

  def fetch_level
    case self.attributes['level'].to_sym
    when :client_era
      return ClientEra.where(slug: self.slug).first
    when :client_version
      return ClientVersion.where(slug: self.slug).first
    when :client_patch
      return ClientPatch.where(slug: self.slug).first
    when :client_build
      return ClientBuild.where(slug: self.slug).first
    end
  end

  # Builds a tree of targets, starting with self, and working up to the era-level target.
  def target_tree
    tree = []

    tree << self.level.build.target if self.level.build?
    tree << self.level.patch.target if self.level.patch? || self.level.build?
    tree << self.level.version.target if self.level.version? || self.level.patch? || self.level.build?
    tree << self.level.era.target

    tree
  end
end
