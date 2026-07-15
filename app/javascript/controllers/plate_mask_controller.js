import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.format()
  }

  format() {
    let value = this.element.value.toUpperCase().replace(/[^A-Z0-9]/g, "")
    if (value.length > 3) {
      value = value.slice(0, 3) + "-" + value.slice(3, 7)
    }
    if (value.length > 8) {
      value = value.slice(0, 8)
    }
    this.element.value = value
  }
}
