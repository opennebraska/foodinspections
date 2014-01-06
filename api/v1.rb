require 'sinatra/base'
require 'active_support/all'
require './helpers/init'

# /api/v1/*
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

  get '/firms/bbox/:bbox' do
    firms ||= Firm.bbox(params[:bbox]) || halt(404)
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
  
  get '/inspections/for/:id/summary' do
    inspections ||= Inspection.firm_summary_array(params[:id]) || halt(404)
    format_response(inspections, request.accept)
  end
  
  get '/inspections/for/:id/on/:date' do
    inspections ||= Inspection.all(:firm_id => params[:id], :inspection_date => params[:date]) || halt(404)
    format_response(inspections, request.accept)
  end
  
  get '/inspections/for/:id/on/:date/summary' do
    inspections ||= Inspection.dated_firm_summary(params[:id], params[:date]) || halt(404)
    format_response(inspections, request.accept)
  end
  
  get '/parent/name/:name' do
    firms ||= Firm.byparent('%' + params[:name] + '%') || halt(404)
    format_response(firms, request.accept)
  end
  
  get '/areas' do
    format_response(Area.all, request.accept)
  end
  
  get '/areas/:id' do
    area ||= Area.get(params[:id]) || halt(404)
    format_response(area, request.accept)
  end
  
  get '/areas/:id/counties' do
    area ||= Area.counties(params[:id]) || halt(404)
    format_response(area, request.accept)
  end
  
  get '/areas/year/:year' do
    areas ||= Area.all(:year => params[:year]) || halt(404)
    format_response(areas, request.accept)
  end
  
  get '/counties' do
    format_response(County.all, request.accept)
  end
  
  get '/counties/:id' do
    county ||= County.get(params[:id]) || halt(404)
    format_response(county, request.accept)
  end
  
  get '/counties/year/:year' do
    counties ||= County.all(:year => params[:year]) || halt(404)
    format_response(counties, request.accept)
  end
  
  get '/counties/inspector/:id' do
    counties ||= County.byinspector(params[:id]) || halt(404)
    format_response(counties, request.accept)
  end
  
  get '/inspectors' do
    format_response(Inspector.all, request.accept)
  end
  
  get '/inspectors/:id' do
    inspector ||= Inspector.get(params[:id]) || halt(404)
    format_response(inspector, request.accept)
  end
  
  get '/inspectors/:id/counties' do
    counties ||= County.byinspector(params[:id]) || halt(404)
    format_response(counties, request.accept)
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
