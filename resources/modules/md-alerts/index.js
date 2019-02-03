import $ from 'jquery'

export default function () {
  $(function () {
    $('.close-alert').click(function (e) {
      e.preventDefault()

      $(this).parent().remove()
    })
  })
}
