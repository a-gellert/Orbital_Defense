components {
  id: "turret"
  component: "/entities/turret/turret.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"t_blaster\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/all.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 0.15
    y: 0.15
  }
}
embedded_components {
  id: "bullet_factory"
  type: "factory"
  data: "prototype: \"/entities/bullet/bullet.go\"\n"
  ""
}
embedded_components {
  id: "rocket_factory"
  type: "factory"
  data: "prototype: \"/entities/slot/rocket/rocket.go\"\n"
  ""
}
embedded_components {
  id: "bullet_out_factory"
  type: "factory"
  data: "prototype: \"/assets/particles/bullet_out.go\"\n"
  ""
}
