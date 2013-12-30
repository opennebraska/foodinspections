class Firm
  include DataMapper::Resource
  
  property :id,                 Integer
  property :firm_id,            Integer, :key => true
  property :name,               String
  property :parent_name,        String
  property :total_critical,     Integer
  property :total_noncritical,  Integer
  property :address,            Text
  property :lat,                Float, :index => :latlng
  property :lng,                Float, :index => :latlng
  
  has n, :inspections, :child_key => [ :firm_id ]

  def self.bbox(bbox)
    # top, left, bottom, right
    coordinates = bbox.split(',').map {|el| el.to_f || 0.0}
    return all(:lat.lte => coordinates[0], :lat.gte => coordinates[2], :lng.gte => coordinates[1], :lng.lte => coordinates[3])
  end
  
  def self.byname(name)
    ret = []
    
    all_data = Firm.all(:name.like => name)
    all_data.each do |firm|
      ret.push(firm['firm_id'])
    end
    
    new_obj = {
	    'count' => ret.count,
	    'ids' => ret
    }
    return new_obj.to_json
  end
  
  def self.byparent(parent_name)
    ret = []
    
    all_data = Firm.all(:parent_name.like => parent_name)
    all_data.each do |firm|
      ret.push(firm['firm_id'])
    end
    
    new_obj = {
	    'count' => ret.count,
	    'ids' => ret
    }
    return new_obj.to_json
  end
end
