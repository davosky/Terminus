import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["stored", "free"]

  showStored() {
    this.storedTarget.classList.remove("d-none")
    this.freeTarget.classList.add("d-none")
  }

  showFree() {
    this.storedTarget.classList.add("d-none")
    this.freeTarget.classList.remove("d-none")
  }
}
