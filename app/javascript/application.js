// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// A response without the requested frame (e.g. a redirect out of the modal) becomes a normal visit
document.addEventListener("turbo:frame-missing", (event) => {
  event.preventDefault()
  event.detail.visit(event.detail.response)
})
