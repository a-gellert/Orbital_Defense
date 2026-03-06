components {
  id: "enemy"
  component: "/entities/enemy/enemy.script"
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_TRIGGER\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"enemy\"\n"
  "mask: \"bullet\"\n"
  "mask: \"sensor\"\n"
  "mask: \"planet\"\n"
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
  "  data: 7.0\n"
  "}\n"
  ""
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"e_shooter\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/all.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 0.075
    y: 0.075
  }
}
embedded_components {
  id: "bullet_factory"
  type: "factory"
  data: "prototype: \"/entities/bullet/enemy_bullet.go\"\n"
  ""
}
