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
  
  has 1, :inspections, :parent_key => [:firm_id], :child_key => [:firm_id], :required => true, :through => Resource
  
  def self.firm_summary(firm_id)
    inspections ||= Inspection.all(:firm_id => firm_id)
    
    dates = 0
    ret = {}
    inspections.each do |ins|
      if ret[ins.inspection_date.to_s].nil?
        ret[ins.inspection_date.to_s] = {
          'inspector_number' => ins.inspector_number,
          'total_critical' => 0,
          'total_noncritical' => 0,
          'any_followups' => false,
          'ids' => []
        }
        
        dates += 1
      end
      
      ret[ins.inspection_date.to_s]['ids'].push(ins.id)
      ret[ins.inspection_date.to_s]['total_critical'] += ins.critical_violations
      ret[ins.inspection_date.to_s]['total_noncritical'] += ins.noncritical_violations
      ret[ins.inspection_date.to_s]['any_followups'] = true if ins.followup
    end
    
    ret['date_count'] = dates
    return ret
  end
  
  def self.dated_firm_summary(firm_id, date)
    inspections ||= Inspection.all(:firm_id => firm_id, :inspection_date => date)
    
    crit = 0
    noncrit = 0
    ins_id = -1
    
    inspections.each do |ins|
      crit += ins.critical_violations
      noncrit += ins.noncritical_violations
      ins_id = ins.inspector_number
    end
    
    ret = {
      'firm_id' => firm_id,
      'date' => date,
      'total_critical' => crit,
      'total_noncritical' => noncrit,
      'inspector_number' => ins_id
    }
    
    return ret
  end
end