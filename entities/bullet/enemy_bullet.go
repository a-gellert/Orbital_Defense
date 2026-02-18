components {
  id: "bullet"
  component: "/entities/bullet/bullet.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"p_red\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/all.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 0.02
    y: 0.02
  }
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_KINEMATIC\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"bullet\"\n"
  "mask: \"turret\"\n"
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
  "  data: 1.5\n"
  "}\n"
  ""
}
