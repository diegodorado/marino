#= require twitter/bootstrap/transition
#= require twitter/bootstrap/alert
#= require twitter/bootstrap/modal
#= require twitter/bootstrap/dropdown
#= require twitter/bootstrap/scrollspy
#= require twitter/bootstrap/tab
#= require twitter/bootstrap/tooltip
#= require twitter/bootstrap/popover
#= require twitter/bootstrap/button
#= require twitter/bootstrap/collapse
#= require twitter/bootstrap/carousel
#= require twitter/bootstrap/affix
#= require twitter/bootstrap_ujs


jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
