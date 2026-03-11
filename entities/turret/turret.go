components {
  id: "turret"
  component: "/entities/turret/turret.script"
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_TRIGGER\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"sensor\"\n"
  "mask: \"enemy\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_SPHERE\n"
  "    position {\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 1\n"
  "  }\n"
  "  data: 8.0\n"
  "}\n"
  ""
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"t_racket\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/all.atlas\"\n"
  "}\n"
  ""
  position {
    y: 6.0
  }
  rotation {
    z: 0.70710677
    w: 0.70710677
  }
  scale {
    x: 0.06
    y: 0.06
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
  data: "prototype: \"/entities/rocket/rocket.go\"\n"
  ""
}
