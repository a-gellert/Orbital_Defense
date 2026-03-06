components {
  id: "slot"
  component: "/entities/slot/slot.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"s_purple\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/all.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 0.04
    y: 0.04
  }
}
