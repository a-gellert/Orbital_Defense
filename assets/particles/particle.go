components {
  id: "pink_copy"
  component: "/assets/particles/pink_copy.particlefx"
}
components {
  id: "particle_manager"
  component: "/assets/particles/particle_manager.script"
  properties {
    id: "name_particle"
    value: "#pink_copy"
    type: PROPERTY_TYPE_URL
  }
}
components {
  id: "path_star"
  component: "/assets/particles/path_star.particlefx"
}
components {
  id: "particle_manager1"
  component: "/assets/particles/particle_manager.script"
  properties {
    id: "name_particle"
    value: "#path_star"
    type: PROPERTY_TYPE_URL
  }
}
