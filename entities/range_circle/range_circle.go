components {
  id: "range_circle"
  component: "/entities/range_circle/range_circle.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"circle\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/sprites/gui/gui.atlas\"\n"
  "}\n"
  ""
}
