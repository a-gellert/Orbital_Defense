components {
  id: "damage_label"
  component: "/entities/damage_label/damage_label.script"
  properties {
    id: "color"
    value: "1.0, 0.8, 1.0, 1.0"
    type: PROPERTY_TYPE_VECTOR4
  }
}
embedded_components {
  id: "label"
  type: "label"
  data: "size {\n"
  "  x: 32.0\n"
  "  y: 32.0\n"
  "}\n"
  "text: \"5\"\n"
  "font: \"/druid/fonts/druid_text_bold.font\"\n"
  "material: \"/builtins/fonts/label-df.material\"\n"
  ""
  scale {
    x: 0.8
    y: 0.8
  }
}
