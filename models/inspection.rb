class Inspection
  include DataMapper::Resource
  
  property :id,                      Serial
  property :firm_id,                 Integer
  property :inspection_date,         Date
  property :inspection_type,         Integer
  property :business_type,           Integer
  property :critical_violations,     Integer
  property :noncritical_violations,  Integer
  property :followup,                Boolean
  property :inspector_number,        Integer
  
  has 1, :inspections, :parent_key => [:firm_id], :child_key => [ :firm_id ], :required => true, :through => Resource
end