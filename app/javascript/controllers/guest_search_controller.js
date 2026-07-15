import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
  static values = {
    minLength: { type: Number, default: 0 }
  }

  connect() {
    this.filter()
  }

  filter() {
    const q = this.inputTarget.value.toLowerCase()
    document.querySelectorAll(".guest-row").forEach(row => {
      const text = row.textContent.toLowerCase()
      row.style.display = text.includes(q) ? "" : "none"
    })
  }
}
