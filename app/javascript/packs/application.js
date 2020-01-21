// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import 'src/application.scss'
import 'bootstrap'

import { dom, library } from '@fortawesome/fontawesome-svg-core'
import { faHandHoldingUsd, faTruck, faShoppingCart } from '@fortawesome/free-solid-svg-icons'
import { faAmazon, faFacebook, faInstagram } from '@fortawesome/free-brands-svg-icons'

// We are only using the faTruck, faHandHoldingUsd, faAmazon, faFacebook, faInstagram icons
library.add(faTruck, faHandHoldingUsd, faAmazon, faFacebook, faInstagram, faShoppingCart)

// Replace any existing <i> tags with <svg> and set up a MutationObserver to
// continue doing this as the DOM changes.
dom.watch()

let $ = require('jquery')
let dt = require('datatables.net')
document.addEventListener('turbolinks:load', function () {
  $('#products_table').DataTable({
    paging: false,
    fixedHeader: true
  })
})

import * as intlTelInput from 'intl-tel-input'

document.addEventListener('turbolinks:load', function () {
  // // Change initialize intlInput on all elements with the id phone
  const input = document.querySelector('.phone-input')
  if (input) {
    const instance = intlTelInput(input, { initialCountry: 'gh' })
  }
})