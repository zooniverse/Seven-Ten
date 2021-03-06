class SplitSchema < ApplicationSchema
  def create
    changes required: true
  end

  def update
    changes
  end

  def changes(required = { })
    root do |root_object|
      id :project_id, **required
      string :name, **required
      string :key, **required

      root_object.entity :state, **required do
        enum %w(inactive active complete)
      end

      string :starts_at, format: 'date-time'
      string :ends_at, format: 'date-time'

      additional_properties false
    end
  end
end
