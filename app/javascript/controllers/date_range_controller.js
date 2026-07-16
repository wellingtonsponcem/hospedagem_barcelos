import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import "flatpickr/dist/l10n/pt.js"

export default class extends Controller {
  static targets = ["display", "start", "end"]

  connect() {
    this.picker = flatpickr(this.displayTarget, {
      mode: "range",
      locale: "pt",
      dateFormat: "d/m/Y",
      defaultDate: [
        this.startTarget.value,
        this.endTarget.value
      ],
      onChange: (selectedDates) => {
        if (selectedDates.length === 2) {
          this.startTarget.value = flatpickr.formatDate(selectedDates[0], "Y-m-d")
          this.endTarget.value = flatpickr.formatDate(selectedDates[1], "Y-m-d")
          this.element.requestSubmit()
        }
      }
    })
  }

  disconnect() {
    if (this.picker) this.picker.destroy()
  }
}
