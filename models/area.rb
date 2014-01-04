class Area
  include DataMapper::Resource
  
  property :id,           Serial
  property :inspector_id, Integer
  property :year,         Integer
  property :name,         Text
  
  has 1, :inspectors, :parent_key => [:id], :child_key => [:inspector_id], :required => true, :through => Resource
  has n, :counties, :parent_key => [:id], :child_key => [:area_id], :required => true, :through => Resource
  
  def self.counties(area_id)
    ret = []
    
    County.all(:area_id => area_id).each do |county|
      ret.push(county)
    end
    
    return ret
  end
end