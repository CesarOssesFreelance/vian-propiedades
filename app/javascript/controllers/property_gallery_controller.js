import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "dialog", "enlarged", "thumbnail", "counter", "pause"]

  connect() {
    this.index = 0
    this.paused = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    this.show(0)
    this.restart()
  }

  disconnect() { this.cleanup() }

  cleanup() {
    clearInterval(this.timer)
    if (this.dialogTarget.open) this.dialogTarget.close()
    this.unlock()
  }

  show(index) {
    this.index = (index + this.slideTargets.length) % this.slideTargets.length
    this.slideTargets.forEach((slide, i) => { slide.hidden = i !== this.index })
    const image = this.slideTargets[this.index].querySelector("img")
    this.enlargedTarget.src = image.src
    this.enlargedTarget.alt = image.alt
    this.thumbnailTargets.forEach((thumbnail, i) => thumbnail.setAttribute("aria-pressed", String(i === this.index)))
    this.counterTargets.forEach(counter => { counter.textContent = `${this.index + 1} / ${this.slideTargets.length}` })
  }

  next() { this.show(this.index + 1); this.restart() }
  previous() { this.show(this.index - 1); this.restart() }
  select(event) { this.show(event.params.index) }

  open() {
    clearInterval(this.timer)
    this.previousOverflow = document.body.style.overflow
    document.body.style.overflow = "hidden"
    this.dialogTarget.showModal()
  }

  close() { this.dialogTarget.close() }
  closed() { this.unlock(); this.restart() }

  unlock() {
    if (this.previousOverflow !== undefined) {
      document.body.style.overflow = this.previousOverflow
      this.previousOverflow = undefined
    }
  }

  keydown(event) {
    if (event.key === "ArrowRight") { event.preventDefault(); this.next() }
    if (event.key === "ArrowLeft") { event.preventDefault(); this.previous() }
  }

  toggle() { this.paused = !this.paused; this.restart() }

  restart() {
    clearInterval(this.timer)
    if (this.hasPauseTarget) this.pauseTarget.textContent = this.paused ? "Reanudar" : "Pausar"
    if (!this.paused && !this.dialogTarget.open && this.slideTargets.length > 1 && this.element.isConnected) {
      this.timer = setInterval(() => {
        if (!document.hidden && !this.element.contains(document.activeElement)) this.show(this.index + 1)
      }, 5000)
    }
  }
}
