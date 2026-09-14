# borro todo antes de crear de nuevo, asi correr esto dos veces no duplica nada
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

datos_bikes = [
  ["TM-0001", "Trek Marlin"],
  ["TM-0002", "Trek Marlin"],
  ["TM-0003", "Trek Marlin"],
  ["GE-1001", "Giant Escape"],
  ["GE-1002", "Giant Escape"],
  ["GE-1003", "Giant Escape"],
  ["SR-2001", "Specialized Rockhopper"],
  ["SR-2002", "Specialized Rockhopper"],
  ["CQ-3001", "Cannondale Quick"],
  ["CQ-3002", "Cannondale Quick"],
  ["SA-4001", "Scott Aspect"],
  ["BC-5001", "Bianchi Camaleonte"],
  ["SA-4002", "Scott Aspect"]
]

bikes = {}
datos_bikes.each do |serial, modelo|
  bikes[serial] = Bike.create!(bike_model_id: bike_models[modelo].id, serial_number: serial)
end

Repair.create!(
  bike_id: bikes["TM-0001"].id,
  customer_id: customers["Javier Contreras"].id,
  mechanic_id: nil,
  status: "dropped_off",
  promised_on: 3.days.from_now.to_date,
  picked_up_at: nil,
  created_at: 1.day.ago
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
  created_at: 2.days.ago
)

Repair.create!(
  bike_id: bikes["CQ-3001"].id,
  customer_id: customers["Camila Herrera"].id,
  mechanic_id: mecanico_camila.id,
  status: "diagnosed",
  promised_on: 5.days.from_now.to_date,
  picked_up_at: nil,
  created_at: 1.day.ago
)

# de aca en adelante ya hay cotizacion, asi que aparecen los repair_jobs
repair_5 = Repair.create!(
  bike_id: bikes["SA-4001"].id,
  customer_id: customers["Ignacio Vera"].id,
  mechanic_id: mecanico_matias.id,
  status: "waiting_for_approval",
  promised_on: 3.days.from_now.to_date,
  picked_up_at: nil,
  created_at: 3.days.ago
)
RepairJob.create!(repair_id: repair_5.id, job_id: jobs["Tune-up"].id, price_charged: 35000)
RepairJob.create!(repair_id: repair_5.id, job_id: jobs["Brake adjustment"].id, price_charged: 10000)

repair_6 = Repair.create!(
  bike_id: bikes["BC-5001"].id,
  customer_id: customers["Sofía Bravo"].id,
  mechanic_id: mecanico_diego.id,
  status: "waiting_for_approval",
  promised_on: 2.days.from_now.to_date,
  picked_up_at: nil,
  created_at: 1.day.ago
)
RepairJob.create!(repair_id: repair_6.id, job_id: jobs["Chain replacement"].id, price_charged: 9000)

repair_7 = Repair.create!(
  bike_id: bikes["TM-0002"].id,
  customer_id: customers["Tomás Aguilera"].id,
  mechanic_id: mecanico_camila.id,
  status: "in_progress",
  promised_on: 2.days.ago.to_date,
  picked_up_at: nil,
  created_at: 5.days.ago
)
RepairJob.create!(repair_id: repair_7.id, job_id: jobs["Wheel true"].id, price_charged: 15000)
RepairJob.create!(repair_id: repair_7.id, job_id: jobs["Brake bleed"].id, price_charged: 20000)

repair_8 = Repair.create!(
  bike_id: bikes["GE-1002"].id,
  customer_id: customers["Antonia Reyes"].id,
  mechanic_id: mecanico_matias.id,
  status: "in_progress",
  promised_on: 1.day.from_now.to_date,
  picked_up_at: nil,
  created_at: 2.days.ago
)
RepairJob.create!(repair_id: repair_8.id, job_id: jobs["Gear adjustment"].id, price_charged: 10000)
RepairJob.create!(repair_id: repair_8.id, job_id: jobs["Tyre replacement"].id, price_charged: 12000)

repair_9 = Repair.create!(
  bike_id: bikes["SR-2002"].id,
  customer_id: customers["Rodrigo Paredes"].id,
  mechanic_id: mecanico_diego.id,
  status: "ready",
  promised_on: Date.current,
  picked_up_at: nil,
  created_at: 4.days.ago
)
RepairJob.create!(repair_id: repair_9.id, job_id: jobs["Full bike service"].id, price_charged: 45000)

repair_10 = Repair.create!(
  bike_id: bikes["CQ-3002"].id,
  customer_id: customers["Valeria Campos"].id,
  mechanic_id: mecanico_camila.id,
  status: "ready",
  promised_on: 1.day.from_now.to_date,
  picked_up_at: nil,
  created_at: 3.days.ago
)
RepairJob.create!(repair_id: repair_10.id, job_id: jobs["Bike inspection"].id, price_charged: 15000)
RepairJob.create!(repair_id: repair_10.id, job_id: jobs["Tube replacement"].id, price_charged: 8000)
RepairJob.create!(repair_id: repair_10.id, job_id: jobs["Pedal replacement"].id, price_charged: 10000)

repair_11 = Repair.create!(
  bike_id: bikes["TM-0003"].id,
  customer_id: customers["Javier Contreras"].id,
  mechanic_id: mecanico_diego.id,
  status: "picked_up",
  promised_on: 5.days.ago.to_date,
  picked_up_at: 4.days.ago,
  created_at: 6.days.ago
)
RepairJob.create!(repair_id: repair_11.id, job_id: jobs["Tune-up"].id, price_charged: 35000)
RepairJob.create!(repair_id: repair_11.id, job_id: jobs["Handlebar adjustment"].id, price_charged: 8000)

repair_12 = Repair.create!(
  bike_id: bikes["GE-1003"].id,
  customer_id: customers["Francisca Morales"].id,
  mechanic_id: mecanico_matias.id,
  status: "picked_up",
  promised_on: Date.current,
  picked_up_at: Time.current.change(hour: 16),
  created_at: Time.current.change(hour: 9)
)
RepairJob.create!(repair_id: repair_12.id, job_id: jobs["Flat tyre repair"].id, price_charged: 8000)

repair_13 = Repair.create!(
  bike_id: bikes["SA-4001"].id,
  customer_id: customers["Ignacio Vera"].id,
  mechanic_id: mecanico_camila.id,
  status: "declined",
  promised_on: 1.day.ago.to_date,
  picked_up_at: nil,
  created_at: 1.day.ago
)
RepairJob.create!(repair_id: repair_13.id, job_id: jobs["Suspension service"].id, price_charged: 60000)

repair_14 = Repair.create!(
  bike_id: bikes["BC-5001"].id,
  customer_id: customers["Pedro Salinas"].id,
  mechanic_id: mecanico_diego.id,
  status: "picked_up",
  promised_on: 10.months.ago.to_date + 5.days,
  picked_up_at: 10.months.ago + 6.days,
  created_at: 10.months.ago
)
RepairJob.create!(repair_id: repair_14.id, job_id: jobs["Tune-up"].id, price_charged: 30000)
RepairJob.create!(repair_id: repair_14.id, job_id: jobs["Cassette replacement"].id, price_charged: 20000)

Repair.create!(
  bike_id: bikes["CQ-3001"].id,
  customer_id: customers["Sofía Bravo"].id,
  mechanic_id: nil,
  status: "dropped_off",
  promised_on: 6.days.from_now.to_date,
  picked_up_at: nil,
  created_at: Time.current
)
