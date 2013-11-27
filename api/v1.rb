require 'sinatra/base'

get '/api/v1/firms' do
  format_response(Firm.all, request.accept)
end

get '/api/v1/firms/:id' do
  firm ||= Firm.get(params[:id]) || halt(404)
  format_response(firm, request.accept)
end

get '/api/v1/firms/in/:lat/:lng/:radius' do
  firms ||= Firm.inarea(params[:lat], params[:lng], params[:radius]) || halt(404)
  format_response(firms, request.accept)
end

get '/api/v1/firms/by/name/:name' do
  firms ||= Firm.all(:name.ilike => '%' + params[:name] + '%') || halt(404)
  format_response(firms, request.accept)
end

get '/api/v1/inspections' do
  format_response(Inspection.all, request.accept)
end

get '/api/v1/inspections/:id' do
  inspection ||= Inspection.get(params[:id]) || halt(404)
  format_response(inspection, request.accept)
end

get '/api/v1/inspections/for/:id' do
  inspections ||= Inspection.all(:firm_id => params[:id]) || halt(404)
  format_response(inspections, request.accept)
end

get '/api/v1/parent/by/name/:name' do
  firms ||= Firm.all(:parent_name.like => '%' + params[:name] + '%') || halt(404)
  format_response(firms, request.accept)
end