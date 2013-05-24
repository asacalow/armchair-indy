class CollectionItem
  include Tire::Model::Persistence

  property :irn
  property :creator
  property :role
  property :summary
  property :created_on, type: Date
  property :earliest_created_on, type: Date
  property :latest_created_on, type: Date
  property :title
  property :format
  property :medium
  property :support
  property :technique
  property :description
  property :height, type: Float
  property :width, type: Float
  property :unit
  property :inscription
  property :media_irn
end