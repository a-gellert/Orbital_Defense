components {
  id: "orbit_controller"
  component: "/entities/orbit_controller/orbit_controller.script"
}
embedded_components {
  id: "slot_factory"
  type: "factory"
  data: "prototype: \"/entities/slot/slot.go\"\n"
  ""
}
embedded_components {
  id: "station_factory"
  type: "factory"
  data: "prototype: \"/entities/station/station.go\"\n"
  ""
}
