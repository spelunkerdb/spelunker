class ClientBuild < ActiveRecord::Base
  belongs_to  :patch,       class_name: 'ClientPatch',    foreign_key: 'client_patch_id'
  belongs_to  :version,     class_name: 'ClientVersion',  foreign_key: 'client_version_id'
  belongs_to  :era,         class_name: 'ClientEra',      foreign_key: 'client_era_id'

  def self.up_to(number)
    self.where('"client_builds"."number" <= ?', number)
  end

  # Allows treating client build targets the same as any other level target.
  def current_build_id
    self.id
  end

  def current_build
    self
  end

  def build
    self
  end

  def builds
    [self]
  end

  def target
    Target.where(slug: self.slug).first
  end

  def build?
    true
  end

  def patch?
    false
  end

  def version?
    false
  end

  def era?
    false
  end
end
