components {
  id: "planet"
  component: "/entities/planet/planet.script"
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
    x: 0.2
    y: 0.2
  }
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_KINEMATIC\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"planet\"\n"
  "mask: \"enemy\"\n"
  "mask: \"enemy_bulet\"\n"
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
  "  data: 16.0\n"
  "}\n"
  ""
}
embedded_components {
  id: "bullet_factory"
  type: "factory"
  data: "prototype: \"/entities/bullet/bullet.go\"\n"
  ""
}
embedded_components {
  id: "sprite1"
  type: "sprite"
  data: "default_animation: \"p_blue\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/all.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 0.1
    y: 0.15
  }
}
embedded_components {
  id: "sprite2"
  type: "sprite"
  data: "default_animation: \"p_blue\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "size {\n"
  "  x: 253.0\n"
  "  y: 256.0\n"
  "}\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/all.atlas\"\n"
  "}\n"
  ""
  rotation {
    z: 0.70710677
    w: 0.70710677
  }
  scale {
    x: 0.1
    y: 0.15
  }
}
embedded_components {
  id: "bullet_out_factory"
  type: "factory"
  data: "prototype: \"/assets/particles/bullet_out.go\"\n"
  ""
}
