require 'sinatra/base'
require './helpers/init'

class ApiV1 < Sinatra::Base
  get '/firms' do
    format_response(Firm.all, request.accept)
  end
  
  get '/firms/:id' do
    firm ||= Firm.get(params[:id]) || halt(404)
    format_response(firm, request.accept)
  end
  
  get '/firms/in/:lat/:lng/:radius' do
    firms ||= Firm.inarea(params[:lat], params[:lng], params[:radius]) || halt(404)
    format_response(firms, request.accept)
  end
  
  get '/firms/name/:name' do
    firms ||= Firm.byname('%' + params[:name] + '%') || halt(404)
    format_response(firms, request.accept)
  end
  
  get '/inspections' do
    format_response(Inspection.all, request.accept)
  end
  
  get '/inspections/:id' do
    inspection ||= Inspection.get(params[:id]) || halt(404)
    format_response(inspection, request.accept)
  end
  
  get '/inspections/for/:id' do
    inspections ||= Inspection.all(:firm_id => params[:id]) || halt(404)
    format_response(inspections, request.accept)
  end
  
  get '/parent/name/:name' do
    firms ||= Firm.byparent('%' + params[:name] + '%') || halt(404)
    format_response(firms, request.accept)
  end

  # TODO: remove, fix helper
  def format_response(data, accept)
  accept.each do |type|
    return data.to_xml  if type.downcase.eql? 'text/xml'
    return data.to_json if type.downcase.eql? 'application/json'
    return data.to_yaml if type.downcase.eql? 'text/x-yaml'
    return data.to_csv  if type.downcase.eql? 'text/csv'
    return data.to_json
  end
end
end
