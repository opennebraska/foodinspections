class Firm
  include DataMapper::Resource
  
  property :id,                 Integer
  property :firm_id,            Integer, :key => true
  property :name,               String
  property :parent_name,        String
  property :total_critical,     Integer
  property :total_noncritical,  Integer
  property :address,            Text
  property :lat,                Float
  property :lng,                Float
  
  has n, :inspections, :child_key => [ :firm_id ]
  
  def inarea(params[:lat], params[:lng], params[:radius])
    
  end
end