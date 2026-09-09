import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "toggle"]

  open() {
    this.menuTarget.hidden = false
    this.toggleTarget.setAttribute("aria-expanded", "true")
  }

  close(event) {
    if (event?.key === "Escape") {
      event.preventDefault()
      this.toggleTarget.focus()
    }
    this.menuTarget.hidden = true
    this.toggleTarget.setAttribute("aria-expanded", "false")
  }

  toggle() { this.menuTarget.hidden ? this.open() : this.close() }
  leave() { if (!this.element.contains(document.activeElement)) this.close() }
  blur(event) { if (!this.element.contains(event.relatedTarget)) this.close() }
  outside(event) { if (!this.element.contains(event.target)) this.close() }
}
