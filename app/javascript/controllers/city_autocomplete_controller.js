import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  static values = {
    minLength: { type: Number, default: 2 },
    maxResults: { type: Number, default: 10 }
  }

  connect() {
    this.cities = null
    this.selectedIndex = -1
    this.resultsTarget.hidden = true
    this.loadingPromise = this.loadCities()
  }

  async loadCities() {
    const cached = localStorage.getItem("ibge_cities")
    if (cached) {
      this.cities = JSON.parse(cached)
      return
    }
    try {
      const response = await fetch("/cities")
      const data = await response.json()
      if (!Array.isArray(data)) throw new Error("Resposta inválida")
      this.cities = data
      localStorage.setItem("ibge_cities", JSON.stringify(this.cities))
    } catch (err) {
      console.error("Falha ao carregar cidades:", err)
    }
  }

  async search() {
    const query = this.inputTarget.value.trim()
    if (query.length < this.minLengthValue) {
      this.resultsTarget.hidden = true
      return
    }
    if (!this.cities) {
      await this.loadingPromise
    }
    if (!this.cities) return
    const search = query.toLowerCase()
    const filtered = this.cities
      .filter(c => {
        const name = c.cidade.toLowerCase()
        return name.startsWith(search) || name.includes(" " + search)
      })
      .slice(0, this.maxResultsValue)
    this.selectedIndex = -1
    this.renderResults(filtered)
  }

  renderResults(items) {
    if (items.length === 0) {
      this.resultsTarget.hidden = true
      return
    }
    this.resultsTarget.innerHTML = items
      .map((item, i) => `
        <div data-index="${i}" class="px-3 py-2 cursor-pointer hover:bg-primary/10 text-sm" data-action="mousedown->city-autocomplete#select">
          ${item.cidade} / ${item.uf}
        </div>
      `).join("")
    this.resultsTarget.hidden = false
  }

  select(event) {
    const index = event.currentTarget.dataset.index
    const text = this.resultsTarget.children[index]?.textContent
    if (text) {
      this.inputTarget.value = text
      this.resultsTarget.hidden = true
    }
  }

  navigate(event) {
    if (this.resultsTarget.hidden) return
    const items = this.resultsTarget.querySelectorAll("[data-index]")
    if (event.key === "ArrowDown") {
      event.preventDefault()
      this.selectedIndex = Math.min(this.selectedIndex + 1, items.length - 1)
    } else if (event.key === "ArrowUp") {
      event.preventDefault()
      this.selectedIndex = Math.max(this.selectedIndex - 1, -1)
    } else if (event.key === "Enter" && this.selectedIndex >= 0) {
      event.preventDefault()
      items[this.selectedIndex]?.click()
    } else if (event.key === "Escape") {
      this.resultsTarget.hidden = true
    }
    items.forEach((el, i) => {
      el.classList.toggle("bg-primary/10", i === this.selectedIndex)
    })
  }

  hideResults() {
    setTimeout(() => { this.resultsTarget.hidden = true }, 200)
  }
}
