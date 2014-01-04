class Inspector
  include DataMapper::Resource
  
  property :id,       Serial
  property :name,     Text
  property :location, Text
  property :contact,  Text
  property :state,    Text
  
  has 1, :areas, :child_key => [ :inspector_id ]
end