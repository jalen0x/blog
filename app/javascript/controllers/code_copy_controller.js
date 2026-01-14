import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "code"]

  async copy() {
    const code = this.codeTarget.textContent
    
    try {
      await navigator.clipboard.writeText(code)
      this.showCopied()
    } catch {
      this.fallbackCopy(code)
    }
  }

  fallbackCopy(text) {
    const textarea = document.createElement("textarea")
    textarea.value = text
    textarea.style.position = "fixed"
    textarea.style.opacity = "0"
    document.body.appendChild(textarea)
    textarea.select()
    document.execCommand("copy")
    document.body.removeChild(textarea)
    this.showCopied()
  }

  showCopied() {
    const originalText = this.buttonTarget.textContent
    this.buttonTarget.textContent = "Copied!"
    this.buttonTarget.classList.add("copied")
    
    setTimeout(() => {
      this.buttonTarget.textContent = originalText
      this.buttonTarget.classList.remove("copied")
    }, 2000)
  }
}
