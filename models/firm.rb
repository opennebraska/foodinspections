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
  
  def self.inarea(lat, lng, radius)
    query = "SELECT firm_id FROM ne_restaurant_inspections l WHERE ST_Dwithin(l.the_geom::geography, ST_GeogFromText('POINT(" + lng.to_s + " " + lat.to_s + ")'), " + radius.to_s + ")"
    carto_result = CartoDB::Connection.query URI::escape(query)
	
    ret = []
    carto_result[:rows].each do |o|
      ret.push(o[:firm_id])
    end
    
    new_obj = {
		'count' => ret.count,
		'ids' => ret
	}
    return new_obj.to_json

#     ret = []
#     carto_result[:rows].each do |o|
#       ret.push(Firm.get(o[:firm_id]))
#     end
# 
# 	new_obj = {
# 		'total_rows' => ret.count,
# 		'rows' => ret
# 	}
#     return new_obj.to_json
  end
end
