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
  
  def self.inarea(lat, lng, radius)
    radius_in_radians = radius.to_f * Math::PI / 180 / 1000
    
    # Get IDs for firms in the bounds
    query  = 'SELECT firm_id FROM firms WHERE ST_Dwithin(coord::geometry, ST_GeomFromEWKT('
    query += 'ST_SetSRID(ST_MakePoint(' + lng.to_s + ', ' + lat.to_s + '), 4326)), ' + radius_in_radians.to_s + ')'
    ids = DataMapper.repository(:default).adapter.select(query)
    
    # Get all of the actual Firm objects
    ret = []
    ids.each do |id|
      ret.push(Firm.get(id))
    end
    
    return ret
  end
  
  def self.byname(name)
    ret = []
    
    modified_name = name.sub(/'|"/, '%')
    
    all_data = Firm.all(:name.ilike => modified_name)
    all_data.each do |firm|
      ret.push(Firm.get(firm['firm_id']))
    end
    
    return ret
  end
  
  def self.byparent(parent_name)
    ret = []
    
    all_data = Firm.all(:parent_name.like => parent_name)
    all_data.each do |firm|
      ret.push(Firm.get(firm['firm_id']))
    end
    
    return ret
  end
end
