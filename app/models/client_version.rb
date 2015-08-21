class ClientVersion < ActiveRecord::Base
  belongs_to  :current_build,   class_name: 'ClientBuild'
  belongs_to  :era,             class_name: 'ClientEra',    foreign_key: 'client_era_id'

  has_many    :patches,         class_name: 'ClientPatch',  foreign_key: 'client_version_id'
  has_many    :builds,          class_name: 'ClientBuild',  foreign_key: 'client_version_id'

  def target
    Target.where(slug: self.slug).first
  end

  def version
    self
  end

  def build?
    false
  end

  def patch?
    false
  end

  def version?
    true
  end

  def era?
    false
  end
end
