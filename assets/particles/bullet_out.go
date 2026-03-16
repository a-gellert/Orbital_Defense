components {
  id: "particle_manager"
  component: "/assets/particles/particle_manager.script"
  properties {
    id: "name_particle"
    value: "#bullet_out"
    type: PROPERTY_TYPE_URL
  }
  properties {
    id: "destroy"
    value: "true"
    type: PROPERTY_TYPE_BOOLEAN
  }
}
components {
  id: "bullet_out"
  component: "/assets/particles/bullet_out.particlefx"
}
