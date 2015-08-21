class ClientEra < ActiveRecord::Base
  belongs_to  :current_build,   class_name: 'ClientBuild'

  has_many    :versions,        class_name: 'ClientVersion',  foreign_key: 'client_era_id'
  has_many    :patches,         class_name: 'ClientPatch',    foreign_key: 'client_era_id'
  has_many    :builds,          class_name: 'ClientBuild',    foreign_key: 'client_era_id'

  def target
    Target.where(slug: self.slug).first
  end

  def era
    self
  end

  def build?
    false
  end

  def patch?
    false
  end

  def version?
    false
  end

  def era?
    true
  end
end
