# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
require 'digest' 
User.create([{
  :id => 1,
  :email => 'admin', 
  :password => 'admin', 
  :password_confirmation => 'admin',
  :role => 'admin'}])  
VarConf.create([{:id => 1, :titulo =>'Peluquería Luzarra', :name_foto => 'luzarra.jpg'}])
Tipo.create([{:id =>1, :descripcion => 'Ingreso'},{:id => 2, :descripcion => 'Gasto'}])
