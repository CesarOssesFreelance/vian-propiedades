import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.mobileQuery = window.matchMedia("(max-width: 767px)")
    this.handleBreakpointChange = this.handleBreakpointChange.bind(this)
    this.handleBreakpointChange(this.mobileQuery)
    this.mobileQuery.addEventListener("change", this.handleBreakpointChange)
  }

  disconnect() {
    this.mobileQuery.removeEventListener("change", this.handleBreakpointChange)
  }

  handleBreakpointChange(event) {
    if (event.matches) {
      this.element.removeAttribute("open")
    } else {
      this.element.setAttribute("open", "")
    }
  }
}
