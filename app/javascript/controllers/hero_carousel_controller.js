import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "indicator"]

  connect() {
    this.show(0)
    this.restartTimer()
  }

  disconnect() {
    window.clearInterval(this.timer)
  }

  next() {
    this.show(this.index + 1)
    this.restartTimer()
  }

  previous() {
    this.show(this.index - 1)
    this.restartTimer()
  }

  select(event) {
    this.show(event.params.index)
    this.restartTimer()
  }

  show(index) {
    const count = this.slideTargets.length
    if (count === 0) return

    this.index = (index + count) % count
    this.slideTargets.forEach((slide, position) => {
      const active = position === this.index
      slide.classList.toggle("is-active", active)
      slide.setAttribute("aria-hidden", String(!active))
      slide.tabIndex = active ? 0 : -1
    })
    this.indicatorTargets.forEach((indicator, position) => {
      const active = position === this.index
      indicator.classList.toggle("is-active", active)
      indicator.setAttribute("aria-current", String(active))
    })
  }

  restartTimer() {
    window.clearInterval(this.timer)
    if (this.slideTargets.length > 1) {
      this.timer = window.setInterval(() => this.show(this.index + 1), 5000)
    }
  }
}
