# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

=begin
Comment.destroy_all
Attachement.destroy_all
Post.destroy_all
User.destroy_all
Authentication.destroy_all


photo_path = "#{RAILS_ROOT}/test/fixtures/avatars/*.jpg"
Dir.glob(photo_path).entries.each do |e|
  user = User.new
  user.name = Faker::Name.name
  user.email = Faker::Internet.free_email
  user.password = "test"
  user.password_confirmation = "test"
  user.avatar = File.open(e)
  user.save!
end
=end


CropControl.destroy_all

tipo_docs = [  'EX INIC',  'CONSUMO',  'COSECHA',  'MERMAS',  'VENTAS']

100.times do
  cc = CropControl.new
  cc.updater_id = User.all.collect(&:id).sort_by{rand}.first
  cc.store_id = Store.all.collect(&:id).sort_by{rand}.first
  cc.crop_id = Crop.all.collect(&:id).sort_by{rand}.first
  cc.fecha = rand(Date.new(2012)..Date.today).strftime("%d/%m/%Y")
  cc.tipo_doc = tipo_docs[rand(tipo_docs.length)]
  n = rand(-1000..1000)
  cc.entrada = n if n>0
  cc.salida = -n if n<0
  cc.precio_unitario = rand(1..100)
  cc.save
end


