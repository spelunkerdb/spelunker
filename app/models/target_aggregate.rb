class TargetAggregate < ActiveRecord::Base
  belongs_to :target
  belongs_to :aggregated_target, class_name: 'Target'
end
