components {
  id: "station"
  component: "/entities/station/station.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"s_blue\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/all.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 0.1
    y: 0.1
    z: 0.1
  }
}
embedded_components {
  id: "turret_factory"
  type: "factory"
  data: "prototype: \"/entities/turret/turret.go\"\n"
  ""
}
