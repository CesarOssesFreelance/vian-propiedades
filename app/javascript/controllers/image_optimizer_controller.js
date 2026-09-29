import { Controller } from "@hotwired/stimulus"

const MAX_DIMENSION = 2560
const MAX_UNOPTIMIZED_BYTES = 2 * 1024 * 1024
const WEBP_QUALITY = 0.82

export default class extends Controller {
  static targets = ["status", "submit"]

  connect() {
    this.pending = 0
  }

  preventWhileProcessing(event) {
    if (this.pending === 0) return

    event.preventDefault()
    this.showStatus("Espera mientras terminamos de optimizar las imágenes.")
  }

  async optimize(event) {
    const input = event.currentTarget
    const files = Array.from(input.files || [])
    if (files.length === 0) return

    this.pending += 1
    this.updateSubmitState()
    this.showStatus(`Optimizando ${files.length === 1 ? "imagen" : `${files.length} imágenes`}…`)

    try {
      const optimizedFiles = []
      for (const file of files) {
        optimizedFiles.push(await this.optimizeFile(file))
      }

      const transfer = new DataTransfer()
      optimizedFiles.forEach((file) => transfer.items.add(file))
      input.files = transfer.files

      const savedBytes = files.reduce((sum, file) => sum + file.size, 0) -
        optimizedFiles.reduce((sum, file) => sum + file.size, 0)
      const detail = savedBytes > 0 ? ` Se redujeron ${this.formatBytes(savedBytes)}.` : ""
      this.showStatus(`Imágenes listas para subir.${detail}`)
    } catch (error) {
      console.error("No fue posible optimizar las imágenes", error)
      this.showStatus("No pudimos reducir algunas imágenes; se subirán en su formato original.")
    } finally {
      this.pending -= 1
      this.updateSubmitState()
    }
  }

  async optimizeFile(file) {
    if (!file.type.startsWith("image/") || file.type === "image/gif" || file.type === "image/svg+xml") {
      return file
    }

    let image
    try {
      image = await createImageBitmap(file, { imageOrientation: "from-image" })
    } catch (_error) {
      return file
    }

    try {
      const scale = Math.min(1, MAX_DIMENSION / Math.max(image.width, image.height))
      if (scale === 1 && file.size <= MAX_UNOPTIMIZED_BYTES && file.type === "image/webp") return file

      const canvas = document.createElement("canvas")
      canvas.width = Math.max(1, Math.round(image.width * scale))
      canvas.height = Math.max(1, Math.round(image.height * scale))
      canvas.getContext("2d", { alpha: false }).drawImage(image, 0, 0, canvas.width, canvas.height)

      const blob = await new Promise((resolve) => canvas.toBlob(resolve, "image/webp", WEBP_QUALITY))
      if (!blob || blob.size >= file.size) return file

      const basename = file.name.replace(/\.[^.]+$/, "") || "imagen"
      return new File([blob], `${basename}.webp`, { type: "image/webp", lastModified: file.lastModified })
    } finally {
      image.close()
    }
  }

  updateSubmitState() {
    if (this.hasSubmitTarget) this.submitTarget.disabled = this.pending > 0
  }

  showStatus(message) {
    if (!this.hasStatusTarget) return
    this.statusTarget.hidden = false
    this.statusTarget.textContent = message
  }

  formatBytes(bytes) {
    if (bytes < 1024 * 1024) return `${Math.max(1, Math.round(bytes / 1024))} KB`
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
  }
}
