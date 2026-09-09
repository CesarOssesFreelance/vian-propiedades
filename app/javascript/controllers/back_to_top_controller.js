import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.update()
  }

  update() {
    this.element.hidden = window.scrollY < 300
  }

  scrollToTop() {
    const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    window.scrollTo({ top: 0, behavior: reducedMotion ? "instant" : "smooth" })
  }
}
