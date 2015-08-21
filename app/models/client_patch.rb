class ClientPatch < ActiveRecord::Base
  belongs_to  :current_build,   class_name: 'ClientBuild'
  belongs_to  :version,         class_name: 'ClientVersion',  foreign_key: 'client_version_id'
  belongs_to  :era,             class_name: 'ClientEra',      foreign_key: 'client_era_id'

  has_many    :builds,          class_name: 'ClientBuild',    foreign_key: 'client_patch_id'

  def target
    Target.where(slug: self.slug).first
  end

  def build?
    false
  end

  def patch?
    true
  end

  def version?
    false
  end

  def era?
    false
  end
end
