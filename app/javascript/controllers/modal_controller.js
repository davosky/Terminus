import { Controller } from "@hotwired/stimulus"

// Shows the <dialog> as a modal. When it is closed (Esc) the frame that loaded it is
// emptied; a modal that is the page itself goes back to the given URL instead.
export default class extends Controller {
  static values = { back: String }

  connect() {
    if (!this.element.open) this.element.showModal()
  }

  closed() {
    const frame = this.element.closest("turbo-frame")
    if (frame.src) {
      frame.src = null
      frame.innerHTML = ""
    } else {
      Turbo.visit(this.backValue)
    }
  }
}
