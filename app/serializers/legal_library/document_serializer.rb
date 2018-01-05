class LegalLibrary::DocumentSerializer < ActiveModel::Serializer
  attributes :id, :title
  attribute :free_content, if: -> { should_render_details }
  attribute :category_id, if: -> { should_render_details }

  def should_render_details
    @instance_options[:show_details]
  end
end
