import { Controller } from "@hotwired/stimulus"

// Removes a flash message 1.5 seconds after it appears
export default class extends Controller {
  connect() {
    this.timeout = setTimeout(() => this.element.remove(), 1500)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
