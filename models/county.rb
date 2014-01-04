class County
  include DataMapper::Resource
  
  property :id,      Serial
  property :name,    Text
  property :area_id, Integer
  property :year,    Integer
  
  has 1, :areas, :child_key => [:area_id]
  
  def self.byinspector(inspector_id)
    ret = []
    
    Area.all(:inspector_id => inspector_id).each do |area|
      County.all(:area_id => area.id).each do |county|
        ret.push(county)
      end
    end
    
    return ret
  end
end