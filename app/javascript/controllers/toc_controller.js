import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toc"
export default class extends Controller {
  static targets = ["content", "nav", "mobileNav", "mobileDrawer"]

  connect() {
    this.generateTOC()
    this.setupScrollSpy()
    this.initializeActiveLink()
  }

  initializeActiveLink() {
    // Set initial active link based on current scroll position or URL hash
    const hash = window.location.hash.slice(1)
    if (hash) {
      // If there's a hash in URL, activate that link
      this.updateActiveLink(hash)
    } else {
      // Otherwise, find the currently visible heading
      const headings = this.contentTarget.querySelectorAll("h2, h3, h4")
      const activeHeading = this.findActiveHeading(headings)
      if (activeHeading) {
        this.updateActiveLink(activeHeading.id)
      }
    }
  }

  generateTOC() {
    const headings = this.contentTarget.querySelectorAll("h2, h3, h4")

    if (headings.length === 0) {
      this.navTarget.innerHTML = '<p class="text-sm text-gray-500 italic">无目录</p>'
      if (this.hasMobileNavTarget) {
        this.mobileNavTarget.innerHTML = '<p class="text-sm text-gray-500 italic">无目录</p>'
      }
      return
    }

    const tocHTML = this.buildTOCHTML(headings)

    // Set TOC for desktop
    this.navTarget.innerHTML = tocHTML

    // Set TOC for mobile
    if (this.hasMobileNavTarget) {
      this.mobileNavTarget.innerHTML = tocHTML
    }
  }

  buildTOCHTML(headings) {
    const tocList = document.createElement("ul")
    tocList.className = "space-y-2"

    headings.forEach((heading, index) => {
      // Ensure heading has an ID for linking
      if (!heading.id) {
        heading.id = `heading-${index}`
      }

      const level = parseInt(heading.tagName.substring(1))
      const listItem = document.createElement("li")

      // Add indentation based on heading level
      const indent = (level - 2) * 12 // h2=0, h3=12px, h4=24px
      listItem.style.marginLeft = `${indent}px`

      const link = document.createElement("a")
      link.href = `#${heading.id}`
      link.textContent = heading.textContent
      link.className = "block text-sm text-gray-600 hover:text-primary-500 transition-colors duration-200 py-1 border-l-2 border-transparent hover:border-primary-500 pl-3"
      link.dataset.tocTarget = "link"
      link.dataset.headingId = heading.id

      // Smooth scroll on click
      link.addEventListener("click", (e) => {
        e.preventDefault()

        // Immediately update active link
        this.updateActiveLink(heading.id)

        // Smooth scroll to heading
        heading.scrollIntoView({ behavior: "smooth", block: "start" })
        history.pushState(null, null, `#${heading.id}`)

        // Close mobile drawer if open
        if (this.hasMobileDrawerTarget) {
          this.closeMobileToc()
        }
      })

      listItem.appendChild(link)
      tocList.appendChild(listItem)
    })

    return tocList.outerHTML
  }

  setupScrollSpy() {
    const headings = this.contentTarget.querySelectorAll("h2, h3, h4")
    if (headings.length === 0) return

    // Keep track of visible headings
    const visibleHeadings = new Set()

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          const id = entry.target.id

          if (entry.isIntersecting) {
            visibleHeadings.add(id)
          } else {
            visibleHeadings.delete(id)
          }
        })

        // Find the first visible heading
        let activeId = null
        for (const heading of headings) {
          if (visibleHeadings.has(heading.id)) {
            activeId = heading.id
            break
          }
        }

        // Update active states
        this.updateActiveLink(activeId)
      },
      {
        rootMargin: "-80px 0px -80%",
        threshold: [0, 0.25, 0.5, 0.75, 1]
      }
    )

    headings.forEach((heading) => {
      observer.observe(heading)
    })

    // Also update on scroll for better responsiveness
    let scrollTimeout
    window.addEventListener("scroll", () => {
      clearTimeout(scrollTimeout)
      scrollTimeout = setTimeout(() => {
        const activeHeading = this.findActiveHeading(headings)
        if (activeHeading) {
          this.updateActiveLink(activeHeading.id)
        }
      }, 50)
    }, { passive: true })
  }

  findActiveHeading(headings) {
    // Find the heading that is currently most visible at the top of viewport
    for (const heading of headings) {
      const rect = heading.getBoundingClientRect()
      // Check if heading is near the top of viewport (within 200px)
      if (rect.top >= 0 && rect.top <= 200) {
        return heading
      }
    }

    // If no heading is near top, find the last heading above viewport
    let lastAbove = null
    for (const heading of headings) {
      const rect = heading.getBoundingClientRect()
      if (rect.top < 200) {
        lastAbove = heading
      } else {
        break
      }
    }

    return lastAbove
  }

  updateActiveLink(activeId) {
    // Remove active class from all links (both desktop and mobile)
    const allLinks = this.element.querySelectorAll("[data-toc-target='link']")
    allLinks.forEach((l) => {
      l.classList.remove("text-primary-600", "border-primary-600", "font-medium")
      l.classList.add("text-gray-600", "border-transparent")
    })

    // Add active class to the active link
    if (activeId) {
      const allMatchingLinks = this.element.querySelectorAll(`[data-heading-id="${activeId}"]`)
      allMatchingLinks.forEach((l) => {
        l.classList.remove("text-gray-600", "border-transparent")
        l.classList.add("text-primary-600", "border-primary-600", "font-medium")
      })
    }
  }

  toggleMobileToc(event) {
    event.preventDefault()
    if (this.hasMobileDrawerTarget) {
      this.mobileDrawerTarget.classList.toggle("hidden")
    }
  }

  closeMobileToc(event) {
    if (event) {
      event.preventDefault()
    }
    if (this.hasMobileDrawerTarget) {
      this.mobileDrawerTarget.classList.add("hidden")
    }
  }

  stopPropagation(event) {
    event.stopPropagation()
  }
}
