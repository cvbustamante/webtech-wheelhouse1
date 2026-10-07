# borro todo antes de crear de nuevo, asi correr esto dos veces no duplica nada
# (purgo los attachments aparte porque destroy_all de Repair no borra los blobs solo)
ActiveStorage::Attachment.find_each(&:purge)
RepairJob.destroy_all
Repair.destroy_all
Bike.destroy_all
StaffMember.destroy_all
Job.destroy_all
BikeModel.destroy_all
Customer.destroy_all

precios_por_job = {
  "Tune-up" => 35000,
  "Wheel true" => 15000,
  "Brake bleed" => 20000,
  "Chain replacement" => 12000,
  "Flat tyre repair" => 8000,
  "Brake adjustment" => 10000,
  "Gear adjustment" => 10000,
  "Tyre replacement" => 12000,
  "Tube replacement" => 8000,
  "Pedal replacement" => 10000,
  "Handlebar adjustment" => 8000,
  "Bike inspection" => 15000,
  "Full bike service" => 45000,
  "Suspension service" => 60000,
  "Disc brake pad replacement" => 18000,
  "Cassette replacement" => 25000,
  "Bottom bracket replacement" => 22000,
  "Headset adjustment" => 12000,
  "Spoke replacement" => 9000,
  "Fork alignment" => 30000,
  "Frame alignment check" => 20000,
  "Bike wash and lube" => 10000
}

jobs = {}
precios_por_job.each do |nombre, precio|
  jobs[nombre] = Job.create!(name: nombre, price: precio)
end

mecanico_diego = StaffMember.create!(name: "Diego Fuentes", role: "mechanic")
mecanico_camila = StaffMember.create!(name: "Camila Rojas", role: "mechanic")
mecanico_matias = StaffMember.create!(name: "Matías Soto", role: "mechanic")
StaffMember.create!(name: "Valentina Muñoz", role: "counter")

nombres_de_modelo = [
  "Trek Marlin",
  "Giant Escape",
  "Specialized Rockhopper",
  "Cannondale Quick",
  "Scott Aspect",
  "Bianchi Camaleonte"
]

bike_models = {}
nombres_de_modelo.each do |nombre|
  bike_models[nombre] = BikeModel.create!(name: nombre)
end

datos_customers = [
  ["Javier Contreras", "+56 9 1111 1111"],
  ["Francisca Morales", "+56 9 2222 2222"],
  ["Pedro Salinas", "+56 9 3333 3333"],
  ["Camila Herrera", "+56 9 4444 4444"],
  ["Ignacio Vera", "+56 9 5555 5555"],
  ["Sofía Bravo", "+56 9 6666 6666"],
  ["Tomás Aguilera", "+56 9 7777 7777"],
  ["Antonia Reyes", "+56 9 8888 8888"],
  ["Rodrigo Paredes", "+56 9 9999 9999"],
  ["Valeria Campos", "+56 9 1000 0001"],
  ["Martín Ibáñez", "+56 9 1000 0002"]
]

customers = {}
datos_customers.each do |nombre, telefono|
  customers[nombre] = Customer.create!(name: nombre, phone: telefono)
end

# el dueno de cada bike es el customer de la repair mas antigua que le conocemos,
# menos SA-4002 que todavia no ha entrado a reparacion y por eso necesita dueno directo
datos_bikes = [
  ["TM-0001", "Trek Marlin", "Javier Contreras"],
  ["TM-0002", "Trek Marlin", "Tomás Aguilera"],
  ["TM-0003", "Trek Marlin", "Javier Contreras"],
  ["GE-1001", "Giant Escape", "Francisca Morales"],
  ["GE-1002", "Giant Escape", "Antonia Reyes"],
  ["GE-1003", "Giant Escape", "Francisca Morales"],
  ["SR-2001", "Specialized Rockhopper", "Pedro Salinas"],
  ["SR-2002", "Specialized Rockhopper", "Rodrigo Paredes"],
  ["CQ-3001", "Cannondale Quick", "Camila Herrera"],
  ["CQ-3002", "Cannondale Quick", "Valeria Campos"],
  ["SA-4001", "Scott Aspect", "Ignacio Vera"],
  ["BC-5001", "Bianchi Camaleonte", "Pedro Salinas"],
  ["SA-4002", "Scott Aspect", "Martín Ibáñez"]
]

bikes = {}
datos_bikes.each do |serial, modelo, dueno|
  bikes[serial] = Bike.create!(
    bike_model_id: bike_models[modelo].id,
    customer_id: customers[dueno].id,
    serial_number: serial
  )
end

# fotos de intake: reusamos las mismas 6 imagenes de ejemplo entre varias repairs
fotos_dir = Rails.root.join("db/seeds/images")
fotos = Dir[fotos_dir.join("*.jpg")].sort

def foto(fotos, i)
  path = fotos[i % fotos.size]
  { io: File.open(path), filename: File.basename(path), content_type: "image/jpeg" }
end

Repair.create!(
  bike_id: bikes["TM-0001"].id,
  customer_id: customers["Javier Contreras"].id,
  mechanic_id: nil,
  status: "dropped_off",
  promised_on: 3.days.from_now.to_date,
  picked_up_at: nil,
  created_at: 1.day.ago,
  intake_photos: [foto(fotos, 0)]
)

Repair.create!(
  bike_id: bikes["GE-1001"].id,
  customer_id: customers["Francisca Morales"].id,
  mechanic_id: nil,
  status: "dropped_off",
  promised_on: 4.days.from_now.to_date,
  picked_up_at: nil,
  created_at: 2.hours.ago
)

Repair.create!(
  bike_id: bikes["SR-2001"].id,
  customer_id: customers["Pedro Salinas"].id,
  mechanic_id: mecanico_diego.id,
  status: "diagnosed",
  promised_on: 2.days.from_now.to_date,
  picked_up_at: nil,
  created_at: 2.days.ago,
  intake_photos: [foto(fotos, 1)],
  diagnosis: "<div><strong>Diagnosis:</strong> rear derailleur is misaligned and the chain skips under load.</div><ul><li>Adjust derailleur limit screws</li><li>Lubricate chain</li></ul>"
)

Repair.create!(
  bike_id: bikes["CQ-3001"].id,
  customer_id: customers["Camila Herrera"].id,
  mechanic_id: mecanico_camila.id,
  status: "diagnosed",
  promised_on: 5.days.from_now.to_date,
  picked_up_at: nil,
  created_at: 1.day.ago,
  intake_photos: [foto(fotos, 2)],
  diagnosis: "<div><strong>Diagnosis:</strong> front brake pads are worn past the wear line.</div><ul><li>Replace brake pads</li><li>Check rim for grooves</li></ul>"
)

# de aca en adelante arman las repair_jobs antes de guardar (.new + .build),
# si no la validacion de que necesita cotizacion las ve vacias todavia
repair_5 = Repair.new(
  bike_id: bikes["SA-4001"].id,
  customer_id: customers["Ignacio Vera"].id,
  mechanic_id: mecanico_matias.id,
  status: "waiting_for_approval",
  promised_on: 3.days.from_now.to_date,
  picked_up_at: nil,
  created_at: 3.days.ago,
  intake_photos: [foto(fotos, 3)],
  diagnosis: "<div><strong>Diagnosis:</strong> bike needs a full tune-up before the season.</div><ul><li>Tune-up</li><li>Adjust brakes</li></ul>"
)
repair_5.repair_jobs.build(job_id: jobs["Tune-up"].id, price_charged: 35000)
repair_5.repair_jobs.build(job_id: jobs["Brake adjustment"].id, price_charged: 10000)
repair_5.save!

repair_6 = Repair.new(
  bike_id: bikes["BC-5001"].id,
  customer_id: customers["Sofía Bravo"].id,
  mechanic_id: mecanico_diego.id,
  status: "waiting_for_approval",
  promised_on: 2.days.from_now.to_date,
  picked_up_at: nil,
  created_at: 1.day.ago,
  intake_photos: [foto(fotos, 4)],
  diagnosis: "<div><strong>Diagnosis:</strong> chain is stretched and skipping on the smallest cog.</div><ul><li>Replace chain</li></ul>"
)
repair_6.repair_jobs.build(job_id: jobs["Chain replacement"].id, price_charged: 9000)
repair_6.save!

repair_7 = Repair.new(
  bike_id: bikes["TM-0002"].id,
  customer_id: customers["Tomás Aguilera"].id,
  mechanic_id: mecanico_camila.id,
  status: "in_progress",
  promised_on: 2.days.ago.to_date,
  picked_up_at: nil,
  created_at: 5.days.ago,
  intake_photos: [foto(fotos, 0), foto(fotos, 1), foto(fotos, 2), foto(fotos, 3)],
  diagnosis: "<div><strong>Diagnosis:</strong> wheel is out of true and the brakes rub on one side.</div><ul><li>True the wheel</li><li>Bleed rear brake</li></ul>"
)
repair_7.repair_jobs.build(job_id: jobs["Wheel true"].id, price_charged: 15000)
repair_7.repair_jobs.build(job_id: jobs["Brake bleed"].id, price_charged: 20000)
repair_7.save!

repair_8 = Repair.new(
  bike_id: bikes["GE-1002"].id,
  customer_id: customers["Antonia Reyes"].id,
  mechanic_id: mecanico_matias.id,
  status: "in_progress",
  promised_on: 1.day.from_now.to_date,
  picked_up_at: nil,
  created_at: 2.days.ago,
  intake_photos: [foto(fotos, 5), foto(fotos, 0)],
  diagnosis: "<div><strong>Diagnosis:</strong> shifting is rough and the rear tyre is nearly bald.</div><ul><li>Adjust gears</li><li>Replace rear tyre</li></ul>"
)
repair_8.repair_jobs.build(job_id: jobs["Gear adjustment"].id, price_charged: 10000)
repair_8.repair_jobs.build(job_id: jobs["Tyre replacement"].id, price_charged: 12000)
repair_8.save!

repair_9 = Repair.new(
  bike_id: bikes["SR-2002"].id,
  customer_id: customers["Rodrigo Paredes"].id,
  mechanic_id: mecanico_diego.id,
  status: "ready",
  promised_on: Date.current,
  picked_up_at: nil,
  created_at: 4.days.ago,
  intake_photos: [foto(fotos, 1)],
  diagnosis: "<div><strong>Diagnosis:</strong> customer requested a full service before a long trip.</div><ul><li>Full bike service</li></ul>"
)
repair_9.repair_jobs.build(job_id: jobs["Full bike service"].id, price_charged: 45000)
repair_9.save!

repair_10 = Repair.new(
  bike_id: bikes["CQ-3002"].id,
  customer_id: customers["Valeria Campos"].id,
  mechanic_id: mecanico_camila.id,
  status: "ready",
  promised_on: 1.day.from_now.to_date,
  picked_up_at: nil,
  created_at: 3.days.ago,
  intake_photos: [foto(fotos, 2), foto(fotos, 3)],
  diagnosis: "<div><strong>Diagnosis:</strong> general inspection requested, flat front tyre on arrival.</div><ul><li>Bike inspection</li><li>Replace inner tube</li><li>Replace pedals</li></ul>"
)
repair_10.repair_jobs.build(job_id: jobs["Bike inspection"].id, price_charged: 15000)
repair_10.repair_jobs.build(job_id: jobs["Tube replacement"].id, price_charged: 8000)
repair_10.repair_jobs.build(job_id: jobs["Pedal replacement"].id, price_charged: 10000)
repair_10.save!

repair_11 = Repair.new(
  bike_id: bikes["TM-0003"].id,
  customer_id: customers["Javier Contreras"].id,
  mechanic_id: mecanico_diego.id,
  status: "picked_up",
  promised_on: 5.days.ago.to_date,
  picked_up_at: 4.days.ago,
  created_at: 6.days.ago,
  intake_photos: [foto(fotos, 4)],
  diagnosis: "<div><strong>Diagnosis:</strong> annual tune-up, handlebar was loose.</div><ul><li>Tune-up</li><li>Tighten handlebar</li></ul>"
)
repair_11.repair_jobs.build(job_id: jobs["Tune-up"].id, price_charged: 35000)
repair_11.repair_jobs.build(job_id: jobs["Handlebar adjustment"].id, price_charged: 8000)
repair_11.save!

repair_12 = Repair.new(
  bike_id: bikes["GE-1003"].id,
  customer_id: customers["Francisca Morales"].id,
  mechanic_id: mecanico_matias.id,
  status: "picked_up",
  promised_on: Date.current,
  picked_up_at: Time.current.change(hour: 16),
  created_at: Time.current.change(hour: 9),
  diagnosis: "<div><strong>Diagnosis:</strong> flat tyre from a puncture on the front wheel.</div><ul><li>Patch and reinflate</li></ul>"
)
repair_12.repair_jobs.build(job_id: jobs["Flat tyre repair"].id, price_charged: 8000)
repair_12.save!

repair_13 = Repair.new(
  bike_id: bikes["SA-4001"].id,
  customer_id: customers["Ignacio Vera"].id,
  mechanic_id: mecanico_camila.id,
  status: "declined",
  promised_on: 1.day.ago.to_date,
  picked_up_at: nil,
  created_at: 1.day.ago,
  intake_photos: [foto(fotos, 5)],
  diagnosis: "<div><strong>Diagnosis:</strong> rear suspension feels soft and leaks a little oil.</div><ul><li>Suspension service</li></ul><p>Customer declined given the price.</p>"
)
repair_13.repair_jobs.build(job_id: jobs["Suspension service"].id, price_charged: 60000)
repair_13.save!

repair_14 = Repair.new(
  bike_id: bikes["BC-5001"].id,
  customer_id: customers["Pedro Salinas"].id,
  mechanic_id: mecanico_diego.id,
  status: "picked_up",
  promised_on: 10.months.ago.to_date + 5.days,
  picked_up_at: 10.months.ago + 6.days,
  created_at: 10.months.ago,
  intake_photos: [foto(fotos, 0)],
  diagnosis: "<div><strong>Diagnosis:</strong> routine tune-up with a worn cassette.</div><ul><li>Tune-up</li><li>Replace cassette</li></ul>"
)
repair_14.repair_jobs.build(job_id: jobs["Tune-up"].id, price_charged: 30000)
repair_14.repair_jobs.build(job_id: jobs["Cassette replacement"].id, price_charged: 20000)
repair_14.save!

Repair.create!(
  bike_id: bikes["CQ-3001"].id,
  customer_id: customers["Sofía Bravo"].id,
  mechanic_id: nil,
  status: "dropped_off",
  promised_on: 6.days.from_now.to_date,
  picked_up_at: nil,
  created_at: Time.current,
  intake_photos: [foto(fotos, 1)]
)

# genera las variantes ahora para que la primera vez que alguien abra el sitio
# las miniaturas y las fotos grandes ya esten listas y no haya que procesarlas al vuelo
Repair.find_each do |repair|
  repair.intake_photos.each do |photo|
    photo.variant(:thumb).processed
    photo.variant(:large).processed
  end
end
