import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.format()
  }

  format() {
    let value = this.inputTarget.value.toUpperCase().replace(/[^A-Z0-9]/g, "")
    if (value.length > 3) {
      value = value.slice(0, 3) + "-" + value.slice(3, 7)
    }
    if (value.length > 8) {
      value = value.slice(0, 8)
    }
    this.inputTarget.value = value
  }
}
